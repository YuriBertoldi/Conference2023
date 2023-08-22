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

// O codigo acima nao possui medidas de seguranca adequadas para autenticacao de usuarios. Uma melhoria seria validar o usuario e a senha contra um banco de dados, ao inves de comparar com valores hardcoded. Al√©m disso, a senha deveria ser armazenada de forma segura, como por exemplo, criptografada.

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
    lrInvalidCredentials: Result := 'Usu·rio ou senha incorretos.';
    lrServerError       : Result := 'Erro no servidor.';
  end;
end;

end.

