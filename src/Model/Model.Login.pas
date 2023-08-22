unit Model.Login;

interface

uses Model.Usuario;

type
  TLoginResult = (lrSuccess, lrInvalidCredentials, lrServerError);

  TLoginResultHelper = Record helper for TLoginResult
    function Text : string;
  end;

  TLogin = class
  public
    function AuthenticateUser(const Usuario: TUsuario): TLoginResult;
  end;

implementation

function TLogin.AuthenticateUser(const Usuario: TUsuario): TLoginResult;
begin
  if (Usuario.Username = 'usuario' ) and (Usuario.Password = 'senha') then
    Result := lrSuccess
  else
    Result := lrInvalidCredentials;
end;


{ TLoginResultHelper }

// Função para retornar o texto de acordo com o resultado da autenticação do usuário

function TLoginResultHelper.Text: string;
begin
  case self of
    lrSuccess           : Result := 'Autenticado com sucesso.';
    lrInvalidCredentials: Result := 'Usu�rio ou senha incorretos.';
    lrServerError       : Result := 'Erro no servidor.';
  end;
end;


end.

