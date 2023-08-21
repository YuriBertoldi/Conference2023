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

////Teste unitario
//procedure TestAuthenticateUser;
//var
//  Usuario: TUsuario;
//  LoginResult: TLoginResult;
//begin
//  Usuario.Username := 'usuario';
//  Usuario.Password := 'senha';
//  LoginResult := TLogin.AuthenticateUser(Usuario);
//  Assert(LoginResult = lrSuccess);
//end;

//Neste código, a autenticação de usuário é realizada de forma insegura, pois a senha e o nome de usuário estão hardcoded. Para melhorar a segurança, é recomendável armazenar as credenciais de usuário em um banco de dados e validar as credenciais de usuário contra o banco de dados. Além disso, é recomendável usar criptografia para armazenar as senhas no banco de dados.

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

