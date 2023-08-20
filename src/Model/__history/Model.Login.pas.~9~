unit Model.Login;

interface

uses
  Model.Usuario;

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


//Teste unitario
procedure TestAuthenticateUser;
var
  Usuario: TUsuario;
  LoginResult: TLoginResult;
begin
  Usuario.Username := 'usuario';
  Usuario.Password := 'senha';
  LoginResult := TLogin.AuthenticateUser(Usuario);
  Assert(LoginResult = lrSuccess);
end;


{ TLoginResultHelper }

function TLoginResultHelper.Text: string;
begin
  case self of
    lrSuccess           : Result := 'Autenticado com sucesso.';
    lrInvalidCredentials: Result := 'Usuário ou senha incorretos.';
    lrServerError       : Result := 'Erro no servidor.';
  end;
end;

end.

