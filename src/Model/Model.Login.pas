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

// Função para autenticar usuario, verificando se o nome de usuario e senha estão corretos. Se sim, retorna lrSuccess, caso contrário, retorna lrInvalidCredentials

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

