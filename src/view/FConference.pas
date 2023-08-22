unit FConference;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts, Controller.Login;

type
  TFrmConference = class(TForm)
    LayLogo: TLayout;
    Image1: TImage;
    Image2: TImage;
    Rectangle1: TRectangle;
    Layout1: TLayout;
    Layout2: TLayout;
    Rectangle2: TRectangle;
    Layout3: TLayout;
    Label1: TLabel;
    edUser: TEdit;
    Layout4: TLayout;
    btnLogar: TRectangle;
    Layout5: TLayout;
    Rectangle4: TRectangle;
    Label3: TLabel;
    edPassword: TEdit;
    Label2: TLabel;
    Layout6: TLayout;
    Label4: TLabel;
    Layout7: TLayout;
    lbStatus: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnLogarClick(Sender: TObject);
  private
    { Private declarations }
    FControllerLogin : TLoginController;
    procedure Logar;
    procedure SetUser;
  public
    { Public declarations }
  end;

var
  FrmConference: TFrmConference;

implementation

{$R *.fmx}

procedure TFrmConference.btnLogarClick(Sender: TObject);
begin
  Logar;
end;

procedure TFrmConference.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FControllerLogin.Free;
end;

procedure TFrmConference.FormCreate(Sender: TObject);
begin
  FControllerLogin := TLoginController.Create;
end;

// Procedimento para realizar o login do usuario, setando o usuario e chamando o controller de login para realizar o login e exibir o status

procedure TFrmConference.Logar;
begin
  SetUser;
  FControllerLogin.DoLogin(lbStatus);
end;


procedure TFrmConference.SetUser;
begin
  FControllerLogin.SetUser(edUser.Text, edPassword.Text);
end;

end.
