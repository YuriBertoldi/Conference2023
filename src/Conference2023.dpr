program Conference2023;

uses
  System.StartUpCopy,
  FMX.Forms,
  FConference in 'view\FConference.pas' {FrmConference},
  Model.Usuario in 'Model\Model.Usuario.pas',
  Model.Login in 'Model\Model.Login.pas',
  Controller.Login in 'Controller\Controller.Login.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmConference, FrmConference);
  Application.Run;
end.
