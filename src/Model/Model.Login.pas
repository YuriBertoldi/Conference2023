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

// O codigo acima nao possui boas praticas de seguranca, pois a senha e o usuario estao hardcoded. Para melhorar a seguranca, deve-se armazenar a senha e o usuario em um banco de dados e validar as credenciais do usuario com o banco de dados. Além disso, deve-se usar algoritmos de criptografia para armazenar a senha no banco de dados.

function TLogin.AuthenticateUser(const Usuario: TUsuario): TLoginResult;
begin
  if (Usuario.Username = 'usuario' ) and (Usuario.Password = 'senha') then
    Result := lrSuccess
  else
    Result := lrInvalidCredentials;
end;


{ TLoginResultHelper }

function TLoginResultHelper.Text: string;
begin
  case self of
    lrSuccess           : Result := 'Autenticado com sucesso.';
    lrInvalidCredentials: Result := 'Usu�rio ou senha incorretos.';
    lrServerError       : Result := 'Erro no servidor.';
  end;
end;


end.

