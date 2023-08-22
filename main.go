package main

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"os/exec"
	"regexp"
	"strings"
)

const (
	TAG_SECURITY = "SECURITY"
	TAG_DOCUMENT = "DOCUMENT"
	TAG_TEST     = "TEST"
)

func main() {

	fmt.Println("SECRET:", os.Getenv("OPENAI_API_KEY"))
	fmt.Println("variable:", os.Getenv("APIKEY"))
	CatchApiKeyOpenAI()
	// Obter o hash do commit atual
	commitHash := os.Getenv("GITHUB_SHA")
	fmt.Println("Hash do commit:", commitHash)

	// Obter as alterações do commit
	cmd := exec.Command("git", "diff-tree", "--no-commit-id", "--name-only", "-r", commitHash)
	output, err := cmd.Output()
	if err != nil {
		fmt.Println("Erro ao obter as alterações do commit:", err)
		os.Exit(1)
	}

	// Separar os nomes dos arquivos alterados em um slice
	changedFiles := strings.Split(string(output), "\n")

	// Procurar e requisitar unit para o ChatGPT, apenas .pas
	for _, file := range changedFiles {
		fmt.Printf("Testando extensão : %v\n", file)
		if strings.HasSuffix(file, ".pas") {
			fmt.Printf("Procurando Tag : %v\n", file)
			for ExistTags(file) {
				err := ProcessInDelphiFile(file)
				if err != nil {
					fmt.Printf("Erro ao processar o arquivo %s: %v\n", file, err)
				} else {
					fmt.Printf("Arquivo processado: %s\n", file)
				}
			}
		}
	}
}

func ExistTags(filename string) bool {
	content, err := ioutil.ReadFile(filename)
	if err != nil {
		fmt.Printf("Erro ao ler arquivo : %v\n", err.Error())
		return false
	}

	// Verificar se há o padrão de comentário em Delphi (//)
	pattern := "(//<" + TAG_SECURITY + ">|//<" + TAG_TEST + ">|//<" + TAG_DOCUMENT + ">)"
	match, err := regexp.Match(pattern, content)

	if err != nil {
		fmt.Printf("Erro ao usar regex : %v\n", err.Error())
		return false
	}

	fmt.Printf("Resultado Regex : %v\n", match)
	return match

}

func ExtractCodeTag(content string, tag string) (string, error) {
	var result string

	// Define o padrão de comentários de abertura e fechamento
	startComment := fmt.Sprintf("//<%s>", tag)
	endComment := fmt.Sprintf("//</%s>", tag)

	fmt.Printf("Extraindo tag : %v\n", startComment)

	// Monta a expressão regular com os grupos de captura
	pattern := fmt.Sprintf(`(?s)%s(.*?)%s`, regexp.QuoteMeta(startComment), regexp.QuoteMeta(endComment))
	regex := regexp.MustCompile(pattern)

	// Encontra a primeira correspondência no texto
	match := regex.FindStringSubmatch(content)

	// Verifica se a tag foi encontrada
	if len(match) >= 2 {
		// Extrai o texto capturado (bloco de código)
		code := match[1]
		return code, nil
	}
	return result, nil
}

func FetchCodeFirstTag(code string) (string, string, string) {
	var result string
	var tag string
	var action string

	result, _ = ExtractCodeTag(code, TAG_DOCUMENT)
	tag = TAG_DOCUMENT
	action = "Realize o comentario do fonte a seguir e me devolva o comentário sem acentos na escrita do comentario: "
	if result == "" {
		result, _ = ExtractCodeTag(code, TAG_TEST)
		tag = TAG_TEST
		action = "Crie um metodo de teste unitario para o fonte a seguir: "
	}
	if result == "" {
		result, _ = ExtractCodeTag(code, TAG_SECURITY)
		tag = TAG_SECURITY
		action = "Realize uma analise de segurança no fonte a seguir e me devolva um comentário com as melhorias de segurança sem acentos sem acentos na escrita do comentário: "
	}

	if result == "" {
		panic("Nenhum codigo encontrado")
	}

	return result, tag, action
}

func CatchApiKeyOpenAI() string {
	result := os.Getenv("OPENAI_API_KEY")
	if result == "" {
		println("ApiKey:" + result)
		os.Exit(1)
		panic("Erro: Chave da API não encontrada. Verifique se a secret OPENAI_API_KEY está configurada.")
	}
	return result
}

func GetIndentation(code string, tagUsada string) string {
	startTag := fmt.Sprintf("//<%s>", tagUsada)
	endTag := fmt.Sprintf("//</%s>", tagUsada)
	startIndex := strings.Index(string(code), startTag)
	endIndex := strings.Index(string(code), endTag)

	// Verificar se as tags foram encontradas
	if startIndex != -1 && endIndex != -1 {
		// Obter a indentação do bloco de código original
		indentation := ""
		lines := strings.Split(code, "\n")
		if len(lines) > 0 {
			// Encontrar o espaço ou tabulação no início da primeira linha
			for _, ch := range lines[0] {
				if ch == ' ' || ch == '\t' {
					indentation += string(ch)
				} else {
					break
				}
			}
			return indentation
		}
	}
	return ""
}

func ProcessInDelphiFile(filename string) error {
	var TagUsada string
	var code string
	var action string

	// Ler o conteúdo do arquivo
	content, err := ioutil.ReadFile(filename)
	if err != nil {
		fmt.Printf("Erro ao ler arquivo : %v\n", err.Error())
	}

	// Busca primeiro bloco de codigo de tags encontrado
	code, TagUsada, action = FetchCodeFirstTag(string(content))

	//Pegar token da Api do chatGPT
	apiKey := CatchApiKeyOpenAI()

	prompt := action + string(code) // Usar o conteúdo do arquivo como prompt com a ação que o chatGPT deve realizar

	fmt.Printf("Processando tag : %v\n", TagUsada)

	//Montando Body da requisição
	data := map[string]interface{}{
		"prompt":      prompt,
		"max_tokens":  2048,               // Defina o número máximo de tokens desejado
		"model":       "text-davinci-003", // Especifique o modelo desejado aqui
		"temperature": 0,
	}

	jsonData, err := json.Marshal(data)
	if err != nil {
		return err
	}

	//Criando request
	request, err := http.NewRequest("POST", "https://api.openai.com/v1/completions", bytes.NewBuffer(jsonData))
	if err != nil {
		return err
	}

	request.Header.Set("Content-Type", "application/json")
	request.Header.Set("Authorization", "Bearer "+apiKey)

	// Fazendo a chamada para a API da OpenAI
	client := http.Client{}
	response, err := client.Do(request)
	if err != nil {
		return err
	}
	defer response.Body.Close()

	//pegando retorno da api
	responseData, err := ioutil.ReadAll(response.Body)
	if err != nil {
		return err
	}
	fmt.Printf("Resposta da api : %v\n", string(responseData))

	// Verificar se há erros na resposta
	var responseError struct {
		Error struct {
			Message string `json:"message"`
		} `json:"error"`
	}

	err = json.Unmarshal(responseData, &responseError)
	if err != nil {
		return err
	}

	// Se a API retornar algum erro, lidar aqui
	if responseError.Error.Message != "" {
		return errors.New(responseError.Error.Message)
	}

	// Extrair a tag "text" da resposta
	var responseText struct {
		Choices []struct {
			Text string `json:"text"`
		} `json:"choices"`
	}

	err = json.Unmarshal(responseData, &responseText)
	if err != nil {
		return err
	}
	// Verificar se há escolhas na resposta do chatGPT
	if len(responseText.Choices) > 0 {
		// Obter o texto da primeira escolha
		text := responseText.Choices[0].Text
		fmt.Println("Texto retornado:", text)

		// Encontrar a posição das tags no conteúdo original
		startTag := fmt.Sprintf("//<%s>", TagUsada)
		endTag := fmt.Sprintf("//</%s>", TagUsada)
		startIndex := strings.Index(string(content), startTag)
		endIndex := strings.Index(string(content), endTag)
		indentation := GetIndentation(code, TagUsada)

		// Aplicar a indentação e comentario ao texto retornado pela API
		indentedText := ""
		lines := strings.Split(text, "\n")
		for _, line := range lines {
			if line != "" {
				indentedText += indentation + "//" + line + "\n"
			}
		}

		//Adicionando codigo enviado para api no slice para que não seja removido do arquivo.
		indentedText += code

		// Verificar se as tags foram encontradas
		if startIndex != -1 && endIndex != -1 {
			// Criar um novo slice de bytes para o novo conteúdo
			newContent := make([]byte, 0, len(content)+len(indentedText)-len(code))

			// Copiar o conteúdo antes da primeira tag
			newContent = append(newContent, content[:startIndex]...)

			// Copiar o texto retornado pela API
			newContent = append(newContent, []byte(indentedText)...)

			// Copiar o conteúdo após a última tag
			newContent = append(newContent, content[endIndex+len(endTag):]...)

			fmt.Println("Texto gravado:", newContent)

			// Escrever o conteúdo modificado de volta para o arquivo
			err = ioutil.WriteFile(filename, newContent, os.ModePerm)
			if err != nil {
				return err
			}
		} else {
			return errors.New("tags não encontradas no arquivo")
		}
	} else {
		return errors.New("nenhuma escolha encontrada na resposta")
	}

	return nil
}
