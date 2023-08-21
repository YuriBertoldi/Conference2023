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

//Neste código, a autenticação de usuário é realizada com base em um usuário e senha pré-definidos. Esta abordagem não é segura, pois qualquer pessoa que conheça o usuário e a senha pode acessar o sistema. Para melhorar a segurança, recomenda-se usar um mecanismo de autenticação mais robusto, como autenticação de dois fatores ou autenticação por token. Além disso, recomenda-se armazenar as credenciais de usuário em um banco de dados seguro e criptografado, em vez de armazená-las no código.

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

