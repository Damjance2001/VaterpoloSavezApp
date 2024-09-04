unit MainUI;

// Make cardinals scoped instead of constant. "TPage.Match" instead of "Match"
{$SCOPEDENUMS ON}

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  FMX.Effects, FMX.Filter.Effects, FMX.Edit, IOUtils, JSON, FMX.DialogService,
  FMX.DateTimeCtrls, Math, System.ImageList, FMX.ImgList,
  System.Generics.Collections, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo,
  FMX.ListBox, System.Generics.Defaults;

type
  TPage = (None, Welcome, Login, Dashboard, Profile, EditProfile, Matches,
    ViewMatch, Clubs, ViewClub, News, ViewNews, Favorites, AddMatch, AddNews,
    AdminMail);
  TBackground = (Empty, Stacks, Circles);

  TAccountProp = (Name, Login, Phone, City, Country, Birth, Password, Admin);

  TDatabase = class
  strict private
    class function GetUserFile(Username: string): string;

    // JSON
    class function GetJson(AFile: string): TJSONValue;
    class procedure PutJson(AFile: string; Obj: TJSONValue);

    // Account
    class function GetAccountJSON(Username: string): TJSONObject;
    class procedure PutAccountJSON(Username: string; Obj: TJSONObject);

    class procedure SetProp(Username: string; Prop, Value: string);
    class function GetProp(Username: string; Prop: string): string;
    class function PropID(Prop: TAccountProp): string;

  public
    // Admin
    class function GetAdminMail: TJSONArray;
    class procedure ClearAdminMail;
    class procedure SendAdminMail(Title, Text: string);
    class procedure MarkAdminEmailAsRead(AIndex: integer);

    // Matches
    class procedure AddMatch(First, Second: string; Date: TDate; Time: TTime; History, Extra: string);
    class procedure AddMatchWinning(Index: integer; Person: string; First: boolean);
    class procedure DeleteMatchWinning(Index: integer; GoalIndex: integer);
    class procedure SetMatchEnded(Index: integer);
    class procedure DeleteMatch(Index: integer);
    class procedure IncrementMatchTicketsSold(Index: integer; Increment: integer);
    class procedure GetMatchScore(Index: integer; out FirstTeam: integer; out SecondTeam: integer);
    class function GetMatchGoals(MatchIndex: integer): TJSONArray;
    class function GetMatches: TJSONArray;

    // Clubs
    class procedure AddClub(Name: string);
    class function ClubGetIndex(Name: string): integer;
    class function ClubExists(Name: string): boolean;
    class procedure DeleteClub(Index: integer);
    class function GetClubs: TJSONArray;
    class function GetClubMembers(Index: integer): TJSONArray;
    class procedure ClubAddMember(Index: integer; MemberName: string);
    class procedure ClubDeleteMember(Index: integer; MemberIndex: integer);

    class procedure ClubIncreaseMembersWinning(MemberName: string; Increment: integer=1);

    // News
    class procedure AddNews(Title: string; Date: TDate; Text: string);
    class procedure DeleteNews(Index: integer);
    class function GetNews: TJSONArray;

    // Accounts
    class procedure AccountCreate(Username, Password: string);
    class procedure AccountCreateAdministrator(Username, Password: string);

    class function AccountExists(Username: string): boolean;
    class function AccountIsAdmin(Username: string): boolean;
    class function PasswordCorrect(Username, Password: string): boolean;

    class function GetAccountCount: integer;

    class procedure SetProperty(Username: string; Prop: TAccountProp; Value: string);
    class function GetProperty(Username: string; Prop: TAccountProp): string;

    class function AccountGetFavorites(Username: string): TJSONArray;
    class function AccountHasFavorite(Username: string; Index: string): boolean;
    class procedure AccountToggleFavorite(Username: string; Index: string);
  end;

  TForm1 = class(TForm)
    PageController: TLayout;
    Page_Login: TLayout;
    Layout1: TLayout;
    Rectangle4: TRectangle;
    Label1: TLabel;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    Rectangle5: TRectangle;
    Rectangle20: TRectangle;
    FillRGBEffect1: TFillRGBEffect;
    Label2: TLabel;
    Layout6: TLayout;
    Rectangle6: TRectangle;
    Label3: TLabel;
    Rectangle10: TRectangle;
    FillRGBEffect2: TFillRGBEffect;
    Page_LoginInfo: TLayout;
    Layout8: TLayout;
    Label4: TLabel;
    Layout9: TLayout;
    Layout10: TLayout;
    Layout11: TLayout;
    Rectangle8: TRectangle;
    Rectangle9: TRectangle;
    FillRGBEffect3: TFillRGBEffect;
    Label5: TLabel;
    Controller_Back: TLayout;
    Button1: TButton;
    Label8: TLabel;
    Layout12: TLayout;
    Label6: TLabel;
    Rectangle11: TRectangle;
    Edit1: TEdit;
    Layout13: TLayout;
    Label7: TLabel;
    Rectangle12: TRectangle;
    Edit2: TEdit;
    Page_Menu: TLayout;
    Layout16: TLayout;
    Controller_Title: TLayout;
    Rectangle16: TRectangle;
    Label13: TLabel;
    Page_AccountInfo: TLayout;
    Layout23: TLayout;
    Layout22: TLayout;
    Rectangle24: TRectangle;
    Rectangle25: TRectangle;
    Layout24: TLayout;
    Label16: TLabel;
    Label15: TLabel;
    Rectangle26: TRectangle;
    Layout25: TLayout;
    Layout26: TLayout;
    Rectangle27: TRectangle;
    Button2: TButton;
    Label17: TLabel;
    Layout27: TLayout;
    Rectangle28: TRectangle;
    Label18: TLabel;
    Layout28: TLayout;
    Rectangle29: TRectangle;
    Label19: TLabel;
    Page_AccountEdit: TLayout;
    Layout30: TLayout;
    Layout31: TLayout;
    Rectangle30: TRectangle;
    Layout32: TLayout;
    Label20: TLabel;
    Label21: TLabel;
    Rectangle32: TRectangle;
    Rectangle31: TRectangle;
    Layout34: TLayout;
    Label23: TLabel;
    Rectangle34: TRectangle;
    Edit4: TEdit;
    Layout33: TLayout;
    Label22: TLabel;
    Rectangle33: TRectangle;
    Edit3: TEdit;
    Rectangle35: TRectangle;
    Layout35: TLayout;
    Label24: TLabel;
    Rectangle36: TRectangle;
    Edit5: TEdit;
    Layout36: TLayout;
    Label25: TLabel;
    Rectangle37: TRectangle;
    Edit6: TEdit;
    Rectangle38: TRectangle;
    Rectangle39: TRectangle;
    Layout37: TLayout;
    Label26: TLabel;
    Rectangle40: TRectangle;
    Edit7: TEdit;
    BackgroundController: TPanel;
    Panel2: TPanel;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    Panel1: TPanel;
    Rectangle41: TRectangle;
    Rectangle42: TRectangle;
    Rectangle43: TRectangle;
    Page_Matches: TLayout;
    MatchList: TVertScrollBox;
    Button3: TButton;
    Page_MatchesAdd: TLayout;
    Button6: TButton;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    DateEdit1: TDateEdit;
    TimeEdit1: TTimeEdit;
    Page_MatchesView: TLayout;
    Rectangle44: TRectangle;
    ItemTitleMain: TLabel;
    Label10: TLabel;
    Rectangle45: TRectangle;
    Rectangle46: TRectangle;
    Label11: TLabel;
    Label12: TLabel;
    Rectangle47: TRectangle;
    Label14: TLabel;
    Layout41: TLayout;
    Rectangle48: TRectangle;
    Rectangle49: TRectangle;
    Label34: TLabel;
    Rectangle50: TRectangle;
    Rectangle51: TRectangle;
    Label37: TLabel;
    Rectangle52: TRectangle;
    Label42: TLabel;
    Label43: TLabel;
    ImageList1: TImageList;
    Page_Favorites: TLayout;
    FavoriteMatchList: TVertScrollBox;
    Page_News: TLayout;
    NewsList: TVertScrollBox;
    Button4: TButton;
    Page_NewsAdd: TLayout;
    Button8: TButton;
    Label44: TLabel;
    Edit10: TEdit;
    Label46: TLabel;
    DateEdit2: TDateEdit;
    Memo1: TMemo;
    Label45: TLabel;
    Page_NewsView: TLayout;
    Layout46: TLayout;
    Rectangle61: TRectangle;
    Label63: TLabel;
    TitleNewsBox: TLabel;
    VertScrollBox1: TVertScrollBox;
    Label48: TLabel;
    Button9: TButton;
    Rectangle53: TRectangle;
    Layout47: TLayout;
    Edit12: TEdit;
    Label31: TLabel;
    Label35: TLabel;
    Label38: TLabel;
    Layout48: TLayout;
    Rectangle54: TRectangle;
    Label39: TLabel;
    Button5: TButton;
    Button10: TButton;
    Label9: TLabel;
    Layout49: TLayout;
    Circle4: TCircle;
    Label36: TLabel;
    Label30: TLabel;
    Label32: TLabel;
    Layout50: TLayout;
    Button11: TButton;
    Button7: TButton;
    Label33: TLabel;
    Page_Clubs: TLayout;
    Button12: TButton;
    Page_ClubView: TLayout;
    Rectangle57: TRectangle;
    ItemClubTitleMain: TLabel;
    Rectangle66: TRectangle;
    Label61: TLabel;
    Layout29: TLayout;
    Rectangle67: TRectangle;
    Label64: TLabel;
    Button14: TButton;
    ClubList: TVertScrollBox;
    Rectangle58: TRectangle;
    Button16: TButton;
    ClubMembersList: TVertScrollBox;
    VertScrollBox2: TVertScrollBox;
    GridLayout1: TGridLayout;
    Layout15: TLayout;
    Rectangle7: TRectangle;
    Rectangle13: TRectangle;
    GlowEffect1: TGlowEffect;
    Layout17: TLayout;
    Rectangle14: TRectangle;
    Rectangle15: TRectangle;
    GlowEffect2: TGlowEffect;
    Layout18: TLayout;
    Rectangle17: TRectangle;
    Rectangle18: TRectangle;
    GlowEffect3: TGlowEffect;
    Layout19: TLayout;
    Rectangle19: TRectangle;
    Rectangle21: TRectangle;
    GlowEffect4: TGlowEffect;
    Layout2: TLayout;
    Rectangle55: TRectangle;
    Rectangle56: TRectangle;
    GlowEffect6: TGlowEffect;
    Layout7: TLayout;
    Rectangle59: TRectangle;
    Rectangle60: TRectangle;
    GlowEffect7: TGlowEffect;
    Layout20: TLayout;
    Rectangle22: TRectangle;
    Rectangle23: TRectangle;
    GlowEffect5: TGlowEffect;
    Page_AdminMail: TLayout;
    AdminMailList: TVertScrollBox;
    Layout14: TLayout;
    Button13: TButton;
    Label40: TLabel;
    Rectangle62: TRectangle;
    Label41: TLabel;
    GoalsList: TVertScrollBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    Rectangle63: TRectangle;
    Button15: TButton;
    Button17: TButton;
    Label47: TLabel;
    procedure GoBackClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Layout5Click(Sender: TObject);
    procedure Layout6Click(Sender: TObject);
    procedure Layout11Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Layout17Click(Sender: TObject);
    procedure Rectangle7Click(Sender: TObject);
    procedure Rectangle22Click(Sender: TObject);
    procedure Rectangle19Click(Sender: TObject);
    procedure Rectangle17Click(Sender: TObject);
    procedure Rectangle25Click(Sender: TObject);
    procedure Rectangle27Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Rectangle55Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Rectangle59Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
  private
    { Private declarations }
    // Navigation
    procedure SelectPage(APage: TPage);
    procedure ReloadPage;
    procedure SelectBackground(ABackground: TBackground);
    function GetPageTitle(APage: TPage): string;

    procedure GoBack;

    // UI
    procedure EchoMatchItem(Item: TJSONValue; Container: TFmxObject; ValueItemIndex: integer);
    procedure EchoClubItem(Item: TJSONValue; Container: TFmxObject; ValueItemIndex: integer);
    procedure EchoArticleItem(Item: TJSONValue; Container: TFmxObject; ValueItemIndex: integer);

    procedure EchoClubMember(Member: TJSONObject; Container: TFmxObject; AIndex: Integer);

    // System
    procedure UpdateScaling;

    // String utils
    function StringNullHandle(Str: string; NullReplacement: string='Unknown'): string;

    // Events
    procedure LaunchMatchActivity(Sender: TObject);
    procedure LaunchClubActivity(Sender: TObject);
    procedure LaunchNewsActivity(Sender: TObject);

    procedure ToggleFavoriter(Sender: TObject);
    procedure ButtonDeleteMemberActivity(Sender: TObject);
    procedure ButtonDeleteGoalActivity(Sender: TObject);
    procedure MarkEmailAsReadActivity(Sender: TObject);

    // Accounts
    procedure ResetSession;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  // System
  DirSystem: string;
  DirAccounts: string;
  DirDatabase: string;

  FileMatches: string;
  FileNews: string;
  FileClubs: string;
  FileAdminMail: string;

  TimeFormat: TFormatSettings;

  // Account
  CurrentAccount: string;
  AdminMode: boolean;
  GuestMode: boolean;

  // Navigation
  CurrentPage: TPage;

implementation

{$R *.fmx}
{$R *.LgXhdpiTb.fmx ANDROID}
{$R *.XLgXhdpiTb.fmx ANDROID}

procedure TForm1.GoBackClick(Sender: TObject);
begin
  GoBack;
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
  TDatabase.SetMatchEnded( ItemTitleMain.Tag );

  SelectPage( TPage.Matches );
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
  TDialogService.InputQuery('Add new club', ['Enter the name of the new club'], [''], procedure(const AResult: TModalResult; const AValues: array of string)
    begin
      if AResult <> mrOk then
        Exit;

      if TDatabase.ClubExists(AValues[0]) then begin
        TDialogService.ShowMessage('That club name already exists!');
        Exit;
      end;

      TDatabase.AddClub( AValues[0] );

      // Reload
      ReloadPage;
    end);
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
  TDialogService.MessageDialog('Delete all admin mail?', System.UITypes.TMsgDlgType.mtInformation,
    [
      System.UITypes.TMsgDlgBtn.mbYes,
      System.UITypes.TMsgDlgBtn.mbNo
    ],
    System.UITypes.TMsgDlgBtn.mbNo,
    0,
    procedure(const AResult: System.UITypes.TModalResult)
    begin
      if AResult <> mrYes then
        Exit;

      // Delete
      TDatabase.ClearAdminMail;

      // Reload
      ReloadPage;
    end);
end;

procedure TForm1.Button14Click(Sender: TObject);
begin
  TDialogService.InputQuery('Add new member', ['Enter the name of the member to add to this club'], [''], procedure(const AResult: TModalResult; const AValues: array of string)
    begin
      if AResult <> mrOk then
        Exit;

      TDatabase.ClubAddMember(ItemClubTitleMain.Tag, AValues[0]);

      // Reload
      ReloadPage;
    end);
end;

procedure TForm1.Button16Click(Sender: TObject);
begin
  TDatabase.DeleteClub(ItemClubTitleMain.Tag);

  GoBack;
end;

procedure TForm1.Button17Click(Sender: TObject);
begin
  const Increment = TButton(Sender).Tag;

  TDatabase.IncrementMatchTicketsSold(ItemTitleMain.Tag, Increment);

  // Reload
  ReloadPage;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  SelectPage( TPage.AddMatch );
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  SelectPage( TPage.AddNews );
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  MemberName: string;
  FirstClub: boolean;
begin
  // Get member name
  FirstClub := TButton(Sender).Tag = 0;
  if FirstClub then
    MemberName := ComboBox3.Items[ComboBox3.ItemIndex]
  else
    MemberName := ComboBox4.Items[ComboBox4.ItemIndex];

  // Validate member
  if MemberName = '' then begin
    TDialogService.ShowMessage('Invalid member selected.');
    Exit;
  end;

  // Add to DB
  TDatabase.AddMatchWinning( ItemTitleMain.Tag, MemberName, FirstClub );

  // Database add player winning
  TDatabase.ClubIncreaseMembersWinning( MemberName, +1 );

  // Reload
  ReloadPage;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  // Check if they are -1(no teams) or the same team
  if (ComboBox1.ItemIndex = ComboBox2.ItemIndex) then begin
    ShowMessage('Invalid teams selected.');
    Exit;
  end;

  TDatabase.AddMatch(  ComboBox1.Items[ComboBox1.ItemIndex], ComboBox2.Items[ComboBox2.ItemIndex], DateEdit1.Date, TimeEdit1.Time, '', Edit12.Text );
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  TDatabase.DeleteMatch(ItemTitleMain.Tag);

  GoBack;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  TDatabase.AddNews( Edit10.Text, DateEdit2.Date, Memo1.Text );
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  TDatabase.DeleteNews( TitleNewsBox.Tag );

  GoBack;
end;

procedure TForm1.ButtonDeleteGoalActivity(Sender: TObject);
begin
  const Index = TButton(Sender).Tag;

  // Delete player record
  const PlayerName = TDatabase.GetMatchGoals(ItemTitleMain.Tag)[Index].GetValue<string>('member');
  TDatabase.ClubIncreaseMembersWinning(PlayerName, -1);

  // Delete winning
  TDatabase.DeleteMatchWinning(ItemTitleMain.Tag, Index);

  ReloadPage;
end;

procedure TForm1.ButtonDeleteMemberActivity(Sender: TObject);
begin
  const Index = TButton(Sender).Tag;

  TDatabase.ClubDeleteMember(ItemClubTitleMain.Tag, Index);

  ReloadPage;
end;

procedure TForm1.EchoArticleItem(Item: TJSONValue; Container: TFmxObject;
  ValueItemIndex: integer);
begin
  const Title = Item.GetValue<string>('title');
  const Date = Item.GetValue<Double>('date');

  const R = TRectangle.Create(Container);
  with R do begin
    Parent := Container;

    Align := TAlignLayout.Top;

    Fill.Color := $FFedf2f5;
    Stroke.Color := $FFb1b5b7;
    Height := 100;

    XRadius := 20;
    YRadius := 20;

    Margins.Top := 8;

    Tag := ValueItemIndex;
    HitTest := true;
    OnClick := LaunchNewsActivity;

    Position.Y := 9999999;

    // Teams
    with TLabel.Create(R) do begin
      Parent := R;
      Align := TAlignLayout.Client;
      Margins.Top := 8;
      Margins.Left := 20;
      Margins.Right := 20;

      StyledSettings := [TStyledSetting.Family, TStyledSetting.FontColor];
      Font.Size := 40;
      TextSettings.Font.Size := 20;
      TextSettings.VertAlign := TTextAlign.Leading;

      Text := Title;
    end;
    with TLabel.Create(R) do begin
      Parent := R;
      Align := TAlignLayout.MostBottom;
      Margins.Bottom := 5;
      Margins.Left := 20;
      Margins.Right := 20;
      AutoSize := true;

      StyledSettings := [TStyledSetting.Family, TStyledSetting.FontColor];
      TextSettings.Font.Size := 12;
      TextSettings.FontColor := TAlphaColors.Dimgray;

      Text := DateToStr( Date );
    end;
  end;
end;

procedure TForm1.EchoClubItem(Item: TJSONValue; Container: TFmxObject;
  ValueItemIndex: integer);
begin
  const ClubName = Item.GetValue<string>('name');
  const MemberCount = Item.GetValue<TJSONArray>('members').Count;

  const R = TRectangle.Create(Container);
  with R do begin
    Parent := Container;

    Align := TAlignLayout.Top;

    Fill.Color := $FFa5bbca;
    Height := 50;

    Stroke.Kind := TBrushKind.None;

    Margins.Top := 8;

    Tag := ValueItemIndex;
    HitTest := true;
    OnClick := LaunchClubActivity;

    with TLabel.Create(R) do begin
      Parent := R;
      Align := TAlignLayout.Left;
      Margins.Right := 10;
      Margins.Left := 20;

      StyledSettings := [TStyledSetting.Family, TStyledSetting.FontColor];

      Text := ClubName;
    end;

    Position.Y := 9999999;

    with TLabel.Create(R) do begin
      Parent := R;
      Align := TAlignLayout.MostRight;
      Margins.Right := 20;

      StyledSettings := [TStyledSetting.Family, TStyledSetting.FontColor];
      TextSettings.HorzAlign := TTextAlign.Trailing;

      Text := Format('%D members', [MemberCount]);
    end;
  end;
end;

procedure TForm1.EchoClubMember(Member: TJSONObject; Container: TFmxObject;
  AIndex: Integer);
begin
  const L = TLabel.Create(ClubMembersList);
  with L do begin
    Parent := ClubMembersList;

    Align := TAlignLayout.Top;
    Margins.Top := 4;
    Margins.Left := 20;
    Margins.Right := 20;

    Height := 36;

    StyledSettings := [TStyledSetting.Family, TStyledSetting.FontColor];
    TextSettings.Font.Size := 18;

    Text := Member.GetValue<string>('name');

    // Score
    with TLabel.Create(L) do begin
      Parent := L;
      Align := TAlignLayout.Right;

      Width := 125;

      Text := Format('Score: %D', [Member.GetValue<integer>('score')]);

      TextSettings.HorzAlign := TTextAlign.Trailing;
    end;

    // Delete button
    if AdminMode then
      with TButton.Create(L) do begin
        Parent := L;
        StyleLookup := 'trashtoolbutton';

        Align := TAlignLayout.MostRight;

        Tag := AIndex;
        OnClick := ButtonDeleteMemberActivity;
      end;
  end;
end;

procedure TForm1.EchoMatchItem(Item: TJSONValue; Container: TFmxObject;
  ValueItemIndex: integer);
begin
  const Time = Item.GetValue<Double>('time');
  const First = Item.GetValue<string>('first');

  var WinFirst, WinSecond: integer;
  TDatabase.GetMatchScore(ValueItemIndex, WinFirst, WinSecond);

  const Ended = Item.GetValue<boolean>('over');

  const Second = Item.GetValue<string>('second');
  const History = Item.GetValue<string>('history');

  const R = TRectangle.Create(Container);
  with R do begin
    Parent := Container;

    Align := TAlignLayout.Top;

    Fill.Color := $FFa5bbca;
    Height := 50;

    Stroke.Kind := TBrushKind.None;

    Margins.Top := 8;

    Tag := ValueItemIndex;
    HitTest := true;
    OnClick := LaunchMatchActivity;

    with TLabel.Create(R) do begin
      Parent := R;
      Align := TAlignLayout.MostRight;
      Margins.Right := 20;

      StyledSettings := [TStyledSetting.Family, TStyledSetting.FontColor];
      TextSettings.HorzAlign := TTextAlign.Trailing;

      Text := TimeToStr(Time, TimeFormat);

      if Ended then
        Text := '[ENDED] ' + Text;
    end;

    Position.Y := 9999999;

    // Teams
    const L = TLayout.Create(R);
    with L do begin
      Parent := R;
      Align := TAlignLayout.Client;

      Margins.Left := 20;
    end;
    with TLabel.Create(L) do begin
      Parent := L;
      Align := TAlignLayout.Top;
      Height := 25;

      StyledSettings := [TStyledSetting.Family, TStyledSetting.FontColor];
      TextSettings.Font.Style := [TFontStyle.fsBold];

      Text := First;
    end;
    with TLabel.Create(L) do begin
      Parent := L;
      Align := TAlignLayout.Top;
      Height := 25;

      StyledSettings := [TStyledSetting.Family, TStyledSetting.FontColor];
      TextSettings.Font.Style := [TFontStyle.fsBold];

      Text := Second;
    end;

    // Score
    const W = TLayout.Create(L);
    with W do begin
      Parent := R;
      Align := TAlignLayout.Right;

      Width := 30;
    end;
    with TLabel.Create(W) do begin
      Parent := W;
      Align := TAlignLayout.Top;
      Height := 25;

      StyledSettings := [TStyledSetting.Family, TStyledSetting.FontColor];
      TextSettings.HorzAlign := TTextAlign.Trailing;

      Text := WinFirst.ToString;
    end;
    with TLabel.Create(W) do begin
      Parent := W;
      Align := TAlignLayout.Top;
      Height := 25;

      StyledSettings := [TStyledSetting.Family, TStyledSetting.FontColor];
      TextSettings.HorzAlign := TTextAlign.Trailing;

      Text := WinSecond.ToString;
    end;

    // Fav
    if not GuestMode then
      with TGlyph.Create(R) do begin
        Parent := R;
        Align := TAlignLayout.MostLeft;

        Height := 25;
        Margins.Left := 20;

        Images := ImageList1;

        Tag := ValueItemIndex;
        HitTest := true;
        OnClick := ToggleFavoriter;

        if TDatabase.AccountHasFavorite(CurrentAccount, ValueItemIndex.ToString) then
          ImageIndex := 0
        else
          ImageIndex := 1;
      end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Directories
  DirSystem := IncludeTrailingPathDelimiter((System.SysUtils.GetHomePath)+ Application.Name);
  {$IFDEF MSWINDOWS}
  DirSystem := IncludeTrailingPathDelimiter(DirSystem + 'VManager');
  if not TDirectory.Exists(DirSystem) then
    TDirectory.CreateDirectory(DirSystem);
  {$ENDIF}
  DirAccounts := IncludeTrailingPathDelimiter(DirSystem+'accounts');
  if not TDirectory.Exists(DirAccounts) then
    TDirectory.CreateDirectory(DirAccounts);
  DirDatabase := IncludeTrailingPathDelimiter(DirSystem+'db');
  if not TDirectory.Exists(DirDatabase) then
    TDirectory.CreateDirectory(DirDatabase);

  // Format
  TimeFormat := TFormatSettings.Create;
  TimeFormat.ShortTimeFormat := 'H:M';
  TimeFormat.LongTimeFormat := 'H:M';

  // Files
  FileAdminMail := DirSystem + 'admin-mail.json';

  FileMatches := DirDataBase + 'matches.json';
  FileNews := DirDataBase + 'news.json';
  FileClubs := DirDataBase + 'clubs.json';

  // Create default users
  if TDatabase.GetAccountCount = 0 then begin
    TDatabase.AccountCreateAdministrator('damjan', 'damjan123');
    TDatabase.AccountCreateAdministrator('todor', 'todor123');
  end;

  // Default page
  SelectPage( TPage.Welcome );

  // UI Fix
  {$IFDEF MSWINDOWS}
  Edit1.TextSettings.FontColor := TAlphaColors.Black;
  Edit2.TextSettings.FontColor := TAlphaColors.Black;
  Edit3.TextSettings.FontColor := TAlphaColors.Black;
  Edit4.TextSettings.FontColor := TAlphaColors.Black;
  Edit5.TextSettings.FontColor := TAlphaColors.Black;
  Edit6.TextSettings.FontColor := TAlphaColors.Black;
  Edit7.TextSettings.FontColor := TAlphaColors.Black;
  {$ENDIF}

  // Scaling
  UpdateScaling;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  UpdateScaling;
end;

function TForm1.GetPageTitle(APage: TPage): string;
begin
  case APage of
    TPage.Welcome: ;
    TPage.Login: ;
    TPage.Dashboard: Result := 'VManager';
    TPage.Profile: Result := 'Settings!';
    TPage.EditProfile: Result := 'Edit Profile!';
    TPage.Matches: Result := 'Matches!';
    TPage.ViewMatch: Result := 'Game Day!';
    TPage.AddMatch: Result := 'New match!';
    TPage.Clubs: Result := 'Clubs!';
    TPage.ViewClub: Result := 'The team!';
    TPage.News: Result := 'News';
    TPage.ViewNews: ;
    TPage.AddNews: Result := 'New new!';
    TPage.Favorites: Result := 'Your favorites';
    TPage.AdminMail: Result := 'Important stuff!';

    else Result := 'Unknown';
  end;
end;

procedure TForm1.GoBack;
var
  Next: TPage;
begin
  // Set failure
  Next := TPage.None;

  // Get previous page based on current view
  case CurrentPage of
    TPage.Dashboard,
    TPage.Login: Next := TPage.Welcome;

    TPage.Profile,
    TPage.AdminMail,
    TPage.Matches,
    TPage.Clubs,
    TPage.News,
    TPage.Favorites: Next := TPage.Dashboard;

    TPage.EditProfile: Next := TPage.Profile;

    TPage.AddMatch,
    TPage.ViewMatch: Next := TPage.Matches;

    TPage.ViewClub: Next := TPage.Clubs;

    TPage.AddNews,
    TPage.ViewNews: Next := TPage.News;
  end;

  // If a page was selected, navigate to It
  if Next <> TPage.None then
    SelectPage( Next );
end;

procedure TForm1.LaunchClubActivity(Sender: TObject);
begin
  // Get match info
  const Index = TRectangle(Sender).Tag;

  ItemClubTitleMain.Tag := Index;

  // Open match
  SelectPage( TPage.ViewClub );
end;

procedure TForm1.LaunchMatchActivity(Sender: TObject);
begin
  // Get match info
  const Index = TRectangle(Sender).Tag;
  ItemTitleMain.Tag := Index;

  // Open match
  SelectPage( TPage.ViewMatch );
end;

procedure TForm1.LaunchNewsActivity(Sender: TObject);
begin
  // Get news info
  const Index = TRectangle(Sender).Tag;
  TitleNewsBox.Tag := Index;

  // Open match
  SelectPage( TPage.ViewNews );
end;

procedure TForm1.Layout11Click(Sender: TObject);
begin
  const AccountName = lowercase(Edit1.Text);
  const AccountPass = Edit2.Text;

  ResetSession;

  if AccountName = '' then begin
    ShowMessage('Please type an valid account phone or email.');
    Exit;
  end;

  if AccountPass = '' then  begin
    ShowMessage('Please type a password.');
    Exit;
  end;

  // Log in
  if TDatabase.AccountExists(AccountName) then begin
    if not TDatabase.PasswordCorrect(AccountName, AccountPass) then begin
      ShowMessage('That password is incorrect!');
      Exit;
    end;

    // Log in
    AdminMode := TDatabase.AccountIsAdmin(AccountName);
    CurrentAccount := AccountName;

    // Log
    if AdminMode then
      TDatabase.SendAdminMail('Administrator login', Format('The user "%S" with administrative rights logged in.', [AccountName]));

    // Dashboard
    SelectPage( TPage.Dashboard );
  end
    else
  // Create account
  begin
    TDialogService.MessageDialog('That account was not registered before. Would you like to register It?', System.UITypes.TMsgDlgType.mtInformation,
    [
      System.UITypes.TMsgDlgBtn.mbYes,
      System.UITypes.TMsgDlgBtn.mbNo
    ],
    System.UITypes.TMsgDlgBtn.mbNo,
    0,
    procedure(const AResult: System.UITypes.TModalResult)
    begin
      if AResult <> mrYES then
        Exit;

      // Register
      ShowMessage('We will now create your new account. Don'#39't forget your password! :)');

      // Create
      TDatabase.AccountCreate(AccountName, AccountPass);

      TDatabase.SendAdminMail('Created new account', 'Created new account with name: '+AccountName);

      // Log in
      CurrentAccount := AccountName;

      // Page
      SelectPage( TPage.Dashboard );
    end);
  end;

  // Open dash

end;

procedure TForm1.Layout17Click(Sender: TObject);
begin
  SelectPage( TPage.Matches );
end;

procedure TForm1.Layout5Click(Sender: TObject);
begin
  SelectPage( TPage.Login );
end;

procedure TForm1.Layout6Click(Sender: TObject);
begin
  ResetSession;

  // Guest
  GuestMode := true;

  // Dash
  SelectPage( TPage.Dashboard );
end;

procedure TForm1.MarkEmailAsReadActivity(Sender: TObject);
begin
  const Index = TButton(Sender).Tag;

  TDatabase.MarkAdminEmailAsRead(Index);

  // Reload
  ReloadPage;
end;

procedure TForm1.Rectangle17Click(Sender: TObject);
begin
  SelectPage( TPage.News );
end;

procedure TForm1.Rectangle19Click(Sender: TObject);
begin
  if GuestMode then begin
    ShowMessage('Not avalabile while in Guest mode!');
    Exit;
  end;

  SelectPage( TPage.Favorites );
end;

procedure TForm1.Rectangle22Click(Sender: TObject);
begin
  TDialogService.MessageDialog('Log off', System.UITypes.TMsgDlgType.mtInformation,
    [
      System.UITypes.TMsgDlgBtn.mbYes,
      System.UITypes.TMsgDlgBtn.mbNo
    ],
    System.UITypes.TMsgDlgBtn.mbNo,
    0,
    procedure(const AResult: System.UITypes.TModalResult)
    begin
      case AResult of
        mrYES:
          SelectPage( TPage.Welcome );
        mrNo: ;
      end;
    end);
end;

procedure TForm1.Rectangle25Click(Sender: TObject);
begin
  SelectPage( TPage.EditProfile );
end;

procedure TForm1.Rectangle27Click(Sender: TObject);
begin
  SelectPage( TPage.EditProfile );
end;

procedure TForm1.Rectangle55Click(Sender: TObject);
begin
  SelectPage( TPage.Clubs );
end;

procedure TForm1.Rectangle59Click(Sender: TObject);
begin
  if not AdminMode then begin
    TDialogService.ShowMessage('This option is only avalabile for administrators.');
    Exit;
  end;

  SelectPage( TPage.AdminMail );
end;

procedure TForm1.Rectangle7Click(Sender: TObject);
begin
  if GuestMode then begin
    ShowMessage('Not avalabile while in Guest mode!');
    Exit;
  end;

  SelectPage( TPage.Profile );
end;

procedure TForm1.ReloadPage;
begin
  SelectPage( CurrentPage );
end;

procedure TForm1.ResetSession;
begin
  GuestMode := false;
  AdminMode := false;

  CurrentAccount := '';
end;

procedure TForm1.SelectBackground(ABackground: TBackground);
begin
  // Background selector
  for var I := 0 to BackgroundController.ControlsCount-1 do
    with BackgroundController.Controls[I] do
      if Tag >= 0 then
        Visible := Tag = integer(ABackground);
end;

var
  SortMasterItems: TJSONArray;
  SortExtract: string;
  SortSecondary: string;
function CompareByCustomCriteria(const Left, Right: Integer): Integer;
begin
  const A = SortMasterItems[Left];
  const B = SortMasterItems[Right];

  Result := CompareValue(A.GetValue<Double>(SortExtract), B.GetValue<Double>(SortExtract));

  if (Result = 0) and (SortSecondary <> '') then
    Result := CompareValue(A.GetValue<Double>(SortSecondary), B.GetValue<Double>(SortSecondary));

  // Make descending
  Result := Result * -1;
end;

procedure TForm1.SelectPage(APage: TPage);
begin
  const PreviousPage = CurrentPage;

  // Set the current page index
  CurrentPage := APage;

  // Show the back page controller
  Controller_Back.Visible := not (APage in [TPage.None, TPage.Welcome]);

  // Title controller
  Controller_Title.Visible := not (APage in [TPage.None, TPage.Welcome, TPage.Login, TPage.ViewNews]);
  if Controller_Title.Visible then
    Label13.Text := GetPageTitle(APage);

  // After page setup
  case PreviousPage of
    TPage.EditProfile: begin
      // Save settings
      try
        TDatabase.SetProperty(CurrentAccount, TAccountProp.Name, Edit4.Text);
        TDatabase.SetProperty(CurrentAccount, TAccountProp.Phone, Edit3.Text);
        TDatabase.SetProperty(CurrentAccount, TAccountProp.City, Edit5.Text);
        TDatabase.SetProperty(CurrentAccount, TAccountProp.Country, Edit6.Text);
        TDatabase.SetProperty(CurrentAccount, TAccountProp.Birth, Edit7.Text);
      except
        ShowMessage('Could not save settings!');
      end;
    end;
  end;

  // Pick background
  case APage of
    TPage.Welcome,
    TPage.Login,
    TPage.Dashboard: SelectBackground( TBackground.Stacks );

    TPage.Profile,
    TPage.EditProfile,
    TPage.Matches,
    TPage.ViewMatch,
    TPage.Clubs,
    TPage.ViewClub,
    TPage.News,
    TPage.ViewNews,
    TPage.Favorites,
    TPage.AddMatch,
    TPage.AddNews: SelectBackground( TBackground.Circles );

    else SelectBackground( TBackground.Empty );
  end;

  // Set visibility
  for var I := 0 to PageController.ControlsCount-1 do
    with PageController.Controls[I] do
      if Tag >= 0 then
        Visible := Tag = integer(APage);

  // Process UI messages
  Application.ProcessMessages;

  // Page load data
  case APage of
    TPage.Profile: begin
      Label15.Text := StringNullHandle(TDatabase.GetProperty(CurrentAccount, TAccountProp.Name));

      Label18.Text := StringNullHandle(TDatabase.GetProperty(CurrentAccount, TAccountProp.Phone));
      Label19.Text := StringNullHandle(CurrentAccount);
    end;

    TPage.EditProfile: begin
      Label21.Text := StringNullHandle(TDatabase.GetProperty(CurrentAccount, TAccountProp.Name));

      Edit4.Text := TDatabase.GetProperty(CurrentAccount, TAccountProp.Name);
      Edit3.Text := TDatabase.GetProperty(CurrentAccount, TAccountProp.Phone);
      Edit5.Text := TDatabase.GetProperty(CurrentAccount, TAccountProp.City);
      Edit6.Text := TDatabase.GetProperty(CurrentAccount, TAccountProp.Country);
      Edit7.Text := TDatabase.GetProperty(CurrentAccount, TAccountProp.Birth);
    end;

    TPage.Matches: begin
      // Show management only for admins
      Button3.Visible := AdminMode;

      // Delete all
      for var I := MatchList.Content.ControlsCount-1 downto 0 do
        MatchList.Content.Controls[I].Free;

      // Create new
      const Matches = TDatabase.GetMatches;



      var Sorted: TArray<integer>;
      var LastDay: TDate;
      try
        SetLength(Sorted, Matches.Count);
        for var I := 0 to High(Sorted) do
          Sorted[I] := I;

        // Sort
        SortMasterItems := Matches;
        SortExtract := 'date';
        SortSecondary := 'time';
        TArray.Sort<Integer>(Sorted, TComparer<Integer>.Construct(CompareByCustomCriteria));

        // Write all
        LastDay := 0;
        for var I := 0 to High(Sorted) do begin
          const Index = Sorted[I];
          const Item = Matches[ Index ];

          const ElementDate = Item.GetValue<Double>('date');

          // Date
          if LastDay <> ElementDate then begin
            // Echo date item
            const R = TRectangle.Create(MatchList.Content);
            with R do begin
              Parent := MatchList.Content;

              Align := TAlignLayout.Top;

              Stroke.Kind := TBrushKind.None;
              Fill.Color := $FFb6aeae;

              Height := 22;
              Margins.Top := 12;

              Position.Y := 9999999;

              with TLabel.Create(R) do begin
                Parent := R;
                Align := TAlignLayout.Client;
                Margins.Left := 30; // better distance

                StyledSettings := [TStyledSetting.Family, TStyledSetting.FontColor];
                TextSettings.FontColor := TAlphacolors.White;

                if True then

                if ElementDate = Date then
                  Text := 'Today'
                else
                  Text := DateToStr(ElementDate);
              end;
            end;
          end;
          LastDay := ElementDate;

          // Echo match item
          EchoMatchItem(Item, MatchList.Content, Index);
        end;

        // No matches
        if Matches.Count = 0 then
          with TLabel.Create(MatchList.Content) do begin
            Parent := MatchList.Content;
            Align := TAlignLayout.MostTop;
            Margins.Left := 20;
            Margins.Right := 20;

            AutoSize := true;

            Text := 'There are no matches to display.';
          end;
      finally
        Sorted := [];
        Matches.Free;
      end;
    end;

    TPage.Clubs: begin
      // Show management only for admins
      Button12.Visible := AdminMode;

      // Delete all
      for var I := ClubList.Content.ControlsCount-1 downto 0 do
        ClubList.Content.Controls[I].Free;

      // Create new
      const Clubs = TDatabase.GetClubs;
      try
        // Write all
        for var I := 0 to Clubs.Count-1 do begin
          const Item = Clubs[ I ];

          // Echo club item
          EchoClubItem(Item, ClubList.Content, I);
        end;

        // No clubs
        if Clubs.Count = 0 then
          with TLabel.Create(MatchList.Content) do begin
            Parent := MatchList.Content;
            Align := TAlignLayout.MostTop;
            Margins.Left := 20;
            Margins.Right := 20;

            AutoSize := true;

            Text := 'There are no clubs to display.';
          end;
      finally
        Clubs.Free;
      end;
    end;

    TPage.News: begin
      Page_News.Visible := true; // override for proper UI update

      // Show management only for admins
      Button4.Visible := AdminMode;

      // Delete all
      for var I := NewsList.Content.ControlsCount-1 downto 0 do
        NewsList.Content.Controls[I].Free;

      // Create new
      const News = TDatabase.GetNews;
      var Sorted: TArray<integer>;
      try
        SetLength(Sorted, News.Count);
        for var I := 0 to High(Sorted) do
          Sorted[I] := I;

        // Sort by when the event takes place
        SortMasterItems := News;
        SortExtract := 'date';
        SortSecondary := '';
        TArray.Sort<Integer>(Sorted, TComparer<Integer>.Construct(CompareByCustomCriteria));

        // Write all
        for var I := 0 to High(Sorted) do begin
          const Index = Sorted[I];
          const Item = News[ Index ];

          // Echo match item
          EchoArticleItem(Item, NewsList.Content, Index);
        end;

        // No articles
        if News.Count = 0 then
          with TLabel.Create(NewsList.Content) do begin
            Parent := NewsList.Content;
            Align := TAlignLayout.MostTop;
            Margins.Left := 20;
            Margins.Right := 20;

            AutoSize := true;

            Text := 'There are no articles avalabile to display.';
          end;
      finally
        Sorted := [];
        News.Free;
      end;
    end;

    TPage.ViewMatch: begin
      Layout48.Visible := AdminMode;
      Button15.Visible := AdminMode;
      Button17.Visible := AdminMode;

      // Data
      const Index = ItemTitleMain.Tag;
      const Items = TDataBase.GetMatches;
      try
        // Get match
        const Item = Items[Index];

        // Apply info
        const FirstTeam = Item.GetValue<string>('first');
        const SecondTeam = Item.GetValue<string>('second');

        var WinFirst, WinSecond: integer;
        TDatabase.GetMatchScore(Index, WinFirst, WinSecond);

        const Ended = Item.GetValue<boolean>('over');

        const Time = Item.GetValue<Double>('time');
        const Date = Item.GetValue<Double>('date');
        const History = Item.GetValue<string>('history');
        const Extra = StringNullHandle(Item.GetValue<string>('extra'), 'No information');

        const TicketsSold = Item.GetValue<integer>('tickets');

        // Data
        Label9.Text := DateToStr(Date);
        Label10.Text := TimeToStr(Time, TimeFormat);
        Label11.Text := FirstTeam;
        Label34.Text := FirstTeam;
        Label12.Text := SecondTeam;
        Label37.Text := SecondTeam;
        Label43.Text := Extra;
        Label47.Text := TicketsSold.ToString;

        Label35.Text := WinFirst.ToString;
        Label38.Text := WinSecond.ToString;
        Label9.Text := Format('%D - %D', [WinFirst, WinSecond]);

        Button5.Enabled := not Ended;
        Button10.Enabled := not Ended;
        Button11.Enabled := not Ended;

        // Status
        if Ended then
          Label30.Text := 'Winner is'
        else
          Label30.Text := 'Leading';

        if WinFirst = WinSecond then
          Label32.Text := 'Equality'
        else
        if WinFirst > WinSecond then
          Label32.Text := FirstTeam
        else
          Label32.Text := SecondTeam;

        // Load member list
        const FirstClubIndex = TDatabase.ClubGetIndex(FirstTeam);
        const SecondClubIndex = TDatabase.ClubGetIndex(SecondTeam);
        ComboBox3.Items.Clear;
        ComboBox4.Items.Clear;
        if FirstClubIndex <> -1 then begin
          const Members = TDatabase.GetClubMembers(FirstClubIndex);
          for var I := 0 to Members.Count-1 do
            ComboBox3.Items.Add( Members[I].GetValue<string>('name') );
          ComboBox3.ItemIndex := 0;
        end;
        if SecondClubIndex <> -1 then begin
          const Members = TDatabase.GetClubMembers(SecondClubIndex);
          for var I := 0 to Members.Count-1 do
            ComboBox4.Items.Add( Members[I].GetValue<string>('name') );
          ComboBox4.ItemIndex := 0;
        end;

        // Goals
        const Goals = Item.GetValue<TJSONArray>('goals');

        for var I := GoalsList.Content.ControlsCount-1 downto 0 do
          GoalsList.Content.Controls[I].Free;

        for var I := 0 to Goals.Count-1 do begin
          const First = Goals[I].GetValue<boolean>('first');
          const Member = Goals[I].GetValue<string>('member');

          const R = TRectangle.Create(GoalsList);
          with R do begin
            Parent := GoalsList;

            Align := TAlignLayout.Top;

            Fill.Color := $FFa5bbca;
            Height := 40;
            Stroke.Kind := TBrushKind.None;

            Margins.Top := 4;

            Position.Y := -999;

            Tag := I;

            with TLabel.Create(R) do begin
              Parent := R;
              Align := TAlignLayout.Client;
              Margins.Right := 10;
              Margins.Left := 20;

              StyledSettings := [TStyledSetting.Family, TStyledSetting.FontColor];
              TextSettings.HorzAlign := TTextAlign.Center;

              Text := Format('Scored by %S', [Member]);
            end;

            // Status
            with TCircle.Create(R) do begin
              Parent := R;

              if First then begin
                Fill.Color := TAlphaColors.Lime;
                Stroke.Color := TAlphaColors.Green;
              end else begin
                Fill.Color := TAlphaColors.Red;
                Stroke.Color := TAlphaColors.Maroon;
              end;

              Margins.Top := 10;
              Margins.Left := 10;
              Margins.Bottom := 10;
              Margins.Right := 10;

              Stroke.Thickness := 2;
              Align := TAlignLayout.Left;
            end;
            with TCircle.Create(R) do begin
              Parent := R;

              if not First then begin
                Fill.Color := TAlphaColors.Lime;
                Stroke.Color := TAlphaColors.Green;
              end else begin
                Fill.Color := TAlphaColors.Red;
                Stroke.Color := TAlphaColors.Maroon;
              end;

              Margins.Top := 10;
              Margins.Left := 10;
              Margins.Bottom := 10;
              Margins.Right := 10;

              Stroke.Thickness := 2;
              Align := TAlignLayout.Right;
            end;

            // Delete goal
            if AdminMode then
              with TButton.Create(R) do begin
                Parent := R;
                StyleLookup := 'trashtoolbutton';

                Enabled := not Ended;

                Align := TAlignLayout.MostRight;

                Tag := I;
                OnClick := ButtonDeleteGoalActivity;
              end;
          end;
        end;
      finally
        Items.Free;
      end;
    end;
    TPage.ViewClub: begin
      Layout29.Visible := AdminMode;

      // Data
      const Index = ItemClubTitleMain.Tag;
      const Items = TDataBase.GetClubs;
      try
        // Get match
        const Item = Items[Index];

        // Apply info
        const Name = Item.GetValue<string>('name');
        const Members = Item.GetValue<TJSONArray>('members');

        // Data
        ItemClubTitleMain.Text := Name;

        // Delete all
        for var I := ClubMembersList.Content.ControlsCount-1 downto 0 do
          ClubMembersList.Content.Controls[I].Free;

        // Write all
        for var I := 0 to Members.Count-1 do begin
          const Member = Members[ I ].AsType<TJSONObject>;

          EchoClubMember(Member, ClubMembersList, I);
        end;
      finally
        Items.Free;
      end;
    end;

    TPage.ViewNews: begin
      Button9.Visible := AdminMode;

      const Index = TitleNewsBox.Tag;
      const Items = TDataBase.GetNews;
      try
        // Get match
        const Item = Items[Index];

        // Apply info
        const Title = Item.GetValue<string>('title');
        const Date = Item.GetValue<Double>('date');
        const Text = Item.GetValue<string>('text');

        TitleNewsBox.Text := Title;
        Label63.Text := DateTimeToStr(Date);
        Label48.Text := Text;
      finally
        Items.Free;
      end;
    end;

    TPage.Favorites: begin
      // Delete all
      for var I := FavoriteMatchList.Content.ControlsCount-1 downto 0 do
        FavoriteMatchList.Content.Controls[I].Free;

      // Create new
      const Matches = TDatabase.GetMatches;
      const Favorites = TDatabase.AccountGetFavorites( CurrentAccount );
      var Index, AddedCount: integer;
      AddedCount := 0;
      try
        // Write all
        for var I := 0 to Favorites.Count-1 do begin
          Index := Favorites[I].AsType<integer>;

          // Skip invalid entries
          if (Index >= Matches.Count) or (Index < 0) then
            Continue;

          // Added total
          inc(AddedCount);

          // Get item
          const Item = Matches[ Index ];

          // Echo match item
          EchoMatchItem(Item, FavoriteMatchList.Content, Index);
        end;

        // No favorites
        if AddedCount = 0 then
          with TLabel.Create(FavoriteMatchList.Content) do begin
            Parent := FavoriteMatchList.Content;
            Align := TAlignLayout.MostTop;
            Margins.Left := 20;
            Margins.Right := 20;

            AutoSize := true;

            Text := 'You have not added any favorites to your list yet...';
          end;
      finally
        Matches.Free;
      end;
    end;

    TPage.AddMatch: begin
      ComboBox1.Items.Clear;

      const Teams = TDataBase.GetClubs;
      for var I := 0 to Teams.Count-1 do
        ComboBox1.Items.Add( Teams[I].GetValue<string>('name') );

      ComboBox2.Items.Assign( ComboBox1.Items );

      ComboBox1.ItemIndex := 0;
      ComboBox2.ItemIndex := 0;
    end;

    TPage.AdminMail: begin
      // Delete all
      for var I := AdminMailList.Content.ControlsCount-1 downto 0 do
        AdminMailList.Content.Controls[I].Free;

      // Create new
      const Mail = TDatabase.GetAdminMail;
      var Sorted: TArray<integer>;
      try
        Label40.Text := Format('%D mail', [Mail.Count]);

        // Sort list
        SetLength(Sorted, Mail.Count);
        for var I := 0 to High(Sorted) do
          Sorted[I] := I;

        // Sort by when the event took place
        SortMasterItems := Mail;
        SortExtract := 'time';
        SortSecondary := '';
        TArray.Sort<Integer>(Sorted, TComparer<Integer>.Construct(CompareByCustomCriteria));

        // Write all
        for var I := 0 to High(Sorted) do begin
          const AIndex = Sorted[I];
          const Item = Mail[ AIndex ];

          const Unread = Item.GetValue<boolean>('unread');
          const Time = Item.GetValue<double>('time');
          const Title = Item.GetValue<string>('title');
          const MailText = Item.GetValue<string>('text');

          // Echo
          const R = TRectangle.Create(AdminMailList);
          with R do begin
            Parent := AdminMailList;
            ClipChildren := true;

            Align := TAlignLayout.Top;
            Margins.Top := 8;
            Tag := AIndex;

            Position.Y := 99999;

            Cursor := crHandPoint;

            if Unread then
              Fill.Color := $FFa5bbca;
            Height := 85;

            if Unread then begin
              HitTest := true;
              OnClick := MarkEmailAsReadActivity;
            end else
              HitTest := false;

            with TLabel.Create(R) do begin
              Parent := R;

              Margins.Left := 6;
              Margins.Right := 6;

              Align := TAlignLayout.Top;
              Margins.Top := 8;

              Text := Format('[%S] %S', [DateTimeToStr(Time), Title]);
              if Unread then
                Text := '*' + Text;

              StyledSettings := [TStyledSetting.Family, TStyledSetting.FontColor];
              TextSettings.Font.Style := [TFontStyle.fsBold];
            end;

            with TLabel.Create(R) do begin
              Parent := R;

              Margins.Left := 6;
              Margins.Right := 6;

              Position.Y := 999;

              Align := TAlignLayout.Top;
              Margins.Top := 8;

              Text := MailText;

              AutoSize := true;
              RecalcUpdateRect;
              Repaint;
            end;
          end;
        end;

        // No admin mail
        if Mail.Count = 0 then
          with TLabel.Create(AdminMailList.Content) do begin
            Parent := AdminMailList.Content;
            Align := TAlignLayout.MostTop;
            Margins.Left := 20;
            Margins.Right := 20;

            AutoSize := true;

            Text := 'There is no mail to display.';
          end;
      finally
        Mail.Free;
      end;
    end;
  end;
end;

function TForm1.StringNullHandle(Str, NullReplacement: string): string;
begin
  if Str = '' then
    Result := NullReplacement
  else
    Result := Str;
end;

procedure TForm1.ToggleFavoriter(Sender: TObject);
begin
  TDatabase.AccountToggleFavorite( CurrentAccount, TGlyph(Sender).Tag.ToString );

  with TGlyph(Sender) do
    if ImageIndex = 0 then
      ImageIndex := 1
    else
      ImageIndex := 0;
end;

procedure TForm1.UpdateScaling;
begin
  GridLayout1.ItemWidth := GridLayout1.Width * 0.45;
end;

{ TDatabase }

class procedure TDatabase.AccountCreate(Username, Password: string);
begin
  const JSON = TJSONObject.Create;
  with JSON do
    try
      AddPair(PropID(TAccountProp.Password), Password);

      PutAccountJSON(Username, JSON);
    finally
      Free;
    end;
end;

class procedure TDatabase.AccountCreateAdministrator(Username,
  Password: string);
begin
  AccountCreate(Username, Password);

  SetProperty(Username, TAccountProp.Admin, 'true');
end;

class function TDatabase.AccountExists(Username: string): boolean;
begin
  Result := TFile.Exists( GetUserFile(Username) );
end;

class function TDatabase.AccountGetFavorites(Username: string): TJSONArray;
begin
  const JSON = GetAccountJSON(Username);
  if not JSON.TryGetValue<TJSONArray>('favorites', Result) then begin
    JSON.Free; // free if not required

    Exit( TJSONArray.Create );
  end;
end;

class function TDatabase.AccountHasFavorite(Username: string; Index: string): boolean;
var
  List: TJSONArray;
begin
  Result := false;
  const JSON = GetAccountJSON(Username);
  try
    if not JSON.TryGetValue<TJSONArray>('favorites', List) then
      Exit;

    for var I := 0 to List.Count-1 do
      if List[I].Value = Index then
        Exit(true);
  finally
    JSON.Free;
  end;
end;

class function TDatabase.AccountIsAdmin(Username: string): boolean;
begin
  Result := GetProperty(Username, TAccountProp.Admin) = 'true';
end;

class procedure TDatabase.AccountToggleFavorite(Username: string; Index: string);
var
  List: TJSONArray;
begin
  const JSON = GetAccountJSON(Username);
  try
    if not JSON.TryGetValue<TJSONArray>('favorites', List) then begin
      List := TJSONArray.Create;
      JSON.AddPair('favorites', List);
    end;

    try
      // Delete
      for var I := 0 to List.Count-1 do
      if List[I].Value = Index then begin
        List.Remove(I);
        Exit;
      end;

      // Add
      List.Add(Index);
    finally
      // Write
      PutAccountJSON(Username, JSON);
    end;
  finally
    JSON.Free;
  end;
end;

class procedure TDatabase.AddClub(Name: string);
begin
  const Item = TJSONObject.Create;
  Item.AddPair('name', Name);
  Item.AddPair('members', TJSONArray.Create);

  const JSON = GetClubs;
  try
    JSON.Add( Item );

    PutJson(FileClubs, JSON);
  finally
    JSON.Free;
  end;
end;

class procedure TDatabase.AddMatch(First, Second: string; Date: TDate; Time: TTime; History,
  Extra: string);
begin
  const Item = TJSONObject.Create;
  Item.AddPair('first', First);
  Item.AddPair('second', Second);

  Item.AddPair('goals', TJSONArray.Create);
  Item.AddPair('over', false);

  Item.AddPair('date', Date);
  Item.AddPair('time', Time);
  Item.AddPair('history', History);
  Item.AddPair('extra', Extra);

  Item.AddPair('tickets', 0);

  const JSON = GetMatches;
  try
    JSON.Add( Item );

    PutJson(FileMatches, JSON);
  finally
    JSON.Free;
  end;
end;

class procedure TDatabase.AddMatchWinning(Index: integer; Person: string; First: boolean);
var
  List: TJSONArray;
  Item: TJSONObject;
begin
  const JSON = GetMatches;
  try
    Item := TJSONObject.Create;
    Item.AddPair('first', First);
    Item.AddPair('member', Person);

    // Add to list
    List := (JSON[Index] as TJSONObject).GetValue<TJSONArray>( 'goals' );
    List.Add(Item);

    PutJson(FileMatches, JSON);
  finally
    JSON.Free;
  end;
end;

class procedure TDatabase.AddNews(Title: string; Date: TDate; Text: string);
begin
  const Item = TJSONObject.Create;
  Item.AddPair('title', Title);
  Item.AddPair('date', Date);
  Item.AddPair('text', Text);

  const JSON = GetNews;
  try
    JSON.Add( Item );

    PutJson(FileNews, JSON);
  finally
    JSON.Free;
  end;
end;

class procedure TDatabase.ClearAdminMail;
begin
  // create blank array
  const JSON = TJSONArray.Create;
  try
    PutJson(FileAdminMail, JSON);
  finally
    JSON.Free;
  end;
end;

class procedure TDatabase.ClubAddMember(Index: integer; MemberName: string);
var
  List: TJSONArray;
  Item: TJSONObject;
begin
  const JSON = GetClubs;
  try
    List := JSON.Items[Index].GetValue<TJSONArray>( 'members' );

    // Create item
    Item := TJSONObject.Create;
    Item.AddPair('name', MemberName);
    Item.AddPair('score', 0);

    // Add
    List.Add(Item);

    PutJson(FileClubs, JSON);
  finally
    JSON.Free;
  end;
end;

class procedure TDatabase.ClubDeleteMember(Index, MemberIndex: integer);
var
  List: TJSONArray;
begin
  const JSON = GetClubs;
  try
    List := JSON.Items[Index].GetValue<TJSONArray>( 'members' );

    // Add
    List.Remove(MemberIndex);

    PutJson(FileClubs, JSON);
  finally
    JSON.Free;
  end;
end;

class function TDatabase.ClubExists(Name: string): boolean;
begin
  Result := ClubGetIndex(Name) <> -1;
end;

class function TDatabase.ClubGetIndex(Name: string): integer;
begin
  Result := -1;

  const JSON = GetClubs;
  try
    for var I := 0 to JSON.Count-1 do begin
      const S = JSON.Items[I].GetValue<string>('name');

      if S = Name then
        Exit(I);
    end;
  finally
    JSON.Free;
  end;
end;

class procedure TDatabase.ClubIncreaseMembersWinning(MemberName: string;
  Increment: integer);
var
  List: TJSONArray;
  I, J: integer;
  FoundCount: integer;
begin
  FoundCount := 0;

  const JSON = GetClubs;
  try
    // Access all clubs
    for I := 0 to JSON.Count-1 do begin
      List := JSON.Items[I].GetValue<TJSONArray>( 'members' );

      // Add to all players matching the name
      for J := 0 to List.Count-1 do
        if Lowercase(List[J].GetValue<string>('name')) = Lowercase(MemberName) then begin
          const NewValue = EnsureRange(List[J].GetValue<integer>('score')+Increment, 0, 9999);

          with (List[J] as TJSONObject) do begin
            RemovePair('score');
            AddPair('score', NewValue);
          end;
          Inc(FoundCount);
        end;
    end;

    // Write database
    if FoundCount > 0 then
      PutJson(FileClubs, JSON);
  finally
    JSON.Free;
  end;
end;

class procedure TDatabase.DeleteClub(Index: integer);
begin
  const JSON = GetClubs;
  try
    JSON.Remove( Index );

    PutJson(FileClubs, JSON);
  finally
    JSON.Free;
  end;
end;

class procedure TDatabase.DeleteMatch(Index: integer);
begin
  const JSON = GetMatches;
  try
    JSON.Remove( Index );

    PutJson(FileMatches, JSON);
  finally
    JSON.Free;
  end;
end;

class procedure TDatabase.DeleteMatchWinning(Index, GoalIndex: integer);
var
  List: TJSONArray;
begin
  const JSON = GetMatches;
  try
    // Add to list
    List := (JSON[Index] as TJSONObject).GetValue<TJSONArray>( 'goals' );
    List.Remove( GoalIndex );

    PutJson(FileMatches, JSON);
  finally
    JSON.Free;
  end;
end;

class procedure TDatabase.DeleteNews(Index: integer);
begin
  const JSON = GetNews;
  try
    JSON.Remove( Index );

    PutJson(FileNews, JSON);
  finally
    JSON.Free;
  end;
end;

class function TDatabase.GetAccountCount: integer;
begin
  Result := Length(TDirectory.GetFiles(DirAccounts));
end;

class function TDatabase.GetAccountJSON(Username: string): TJSONObject;
begin
  Result := GetJSON(GetUserFile(Username)) as TJSONObject;
end;

class function TDatabase.GetAdminMail: TJSONArray;
begin
  if not TFile.Exists( FileAdminMail ) then
    Exit( TJSONArray.Create );
  Result := GetJSON( FileAdminMail ) as TJSONArray;
end;

class function TDatabase.GetClubMembers(Index: integer): TJSONArray;
begin
  Result := GetClubs.Items[Index].GetValue<TJSONArray>( 'members' )
end;

class function TDatabase.GetClubs: TJSONArray;
begin
  if not TFile.Exists( FileClubs ) then
    Exit( TJSONArray.Create );
  Result := GetJSON( FileClubs ) as TJSONArray;
end;

class function TDatabase.GetJson(AFile: string): TJSONValue;
begin
  Result := TJSONObject.ParseJSONValue( TFile.ReadAllText( AFile, TEncoding.UTF8 ) );
end;

class function TDatabase.GetMatches: TJSONArray;
begin
  if not TFile.Exists( FileMatches ) then
    Exit( TJSONArray.Create );
  Result := GetJSON( FileMatches ) as TJSONArray;
end;

class function TDatabase.GetMatchGoals(MatchIndex: integer): TJSONArray;
begin
  Result := GetMatches.Items[MatchIndex].GetValue<TJSONArray>('goals');
end;

class procedure TDatabase.GetMatchScore(Index: integer; out FirstTeam,
  SecondTeam: integer);
begin
  FirstTeam := 0;
  SecondTeam := 0;

  const Matches = GetMatches;
  const MatchScores = Matches[Index].GetValue<TJSONArray>('goals');
  try
    for var I := 0 to MatchScores.Count-1 do
      if MatchScores[I].GetValue<boolean>('first') then
        Inc(FirstTeam)
      else
        Inc(SecondTeam);
  finally
    Matches.Free;
  end;
end;

class function TDatabase.GetNews: TJSONArray;
begin
  if not TFile.Exists( FileNews ) then
    Exit( TJSONArray.Create );
  Result := GetJSON( FileNews ) as TJSONArray
end;

class function TDatabase.GetProp(Username: string; Prop: string): string;
begin
  Result := '';

  const JSON = GetAccountJSON(Username);
  try
    if not JSON.TryGetValue<string>(Prop, Result) then
      Result := '';
  finally
    JSON.Free;
  end;
end;

class function TDatabase.GetProperty(Username: string;
  Prop: TAccountProp): string;
begin
  Result := GetProp(Username, PropID(Prop));
end;

class function TDatabase.GetUserFile(Username: string): string;
begin
  Result := Format('%S%S.json', [DirAccounts, Username]);
end;

class procedure TDatabase.IncrementMatchTicketsSold(Index, Increment: integer);
begin
  const JSON = GetMatches;
  try
    const Item = JSON[Index] as TJSONObject;

    const NewValue = EnsureRange(Item.GetValue<integer>('tickets')+Increment, 0, 9999);
    Item.RemovePair('tickets');
    Item.AddPair('tickets', NewValue);

    PutJson(FileMatches, JSON);
  finally
    JSON.Free;
  end;
end;

class procedure TDatabase.MarkAdminEmailAsRead(AIndex: integer);
begin
  const JSON = GetAdminMail;
  try
    const Item = JSON.Items[AIndex];
    (Item as TJSONObject).Get('unread').JsonValue := TJSONBool.Create(false);

    PutJson(FileAdminMail, JSON);
  finally
    JSON.Free;
  end;
end;

class function TDatabase.PasswordCorrect(Username, Password: string): boolean;
begin
  Result := (Password <> '') and (Password = GetProperty(Username, TAccountProp.Password));
end;

class function TDatabase.PropID(Prop: TAccountProp): string;
begin
  case Prop of
    TAccountProp.Name: Result := 'name';
    TAccountProp.Login: Result := 'login';
    TAccountProp.Phone: Result := 'phone';
    TAccountProp.City: Result := 'city';
    TAccountProp.Country: Result := 'country';
    TAccountProp.Birth: Result := 'birth';
    TAccountProp.Password: Result := 'password';
    TAccountProp.Admin: Result := 'administrator';
    else raise Exception.Create('Could not find specified property ID.');
  end;
end;

class procedure TDatabase.PutAccountJSON(Username: string; Obj: TJSONObject);
begin
  PutJSON(GetUserFile(Username), Obj);
end;

class procedure TDatabase.PutJson(AFile: string; Obj: TJSONValue);
begin
  TFile.WriteAllText(AFile, Obj.Format(2), TEncoding.UTF8);
end;

class procedure TDatabase.SendAdminMail(Title, Text: string);
begin
  const Item = TJSONObject.Create;
  Item.AddPair('title', Title);
  Item.AddPair('text', Text);
  Item.AddPair('time', Now);
  Item.AddPair('unread', true);

  const JSON = GetAdminMail;
  try
    JSON.Add( Item );

    PutJson(FileAdminMail, JSON);
  finally
    JSON.Free;
  end;
end;

class procedure TDatabase.SetMatchEnded(Index: integer);
begin
  const JSON = GetMatches;
  try
    const Item = JSON[Index] as TJSONObject;
    const Editor = Item.Get('over');

    Editor.JSONValue := TJSONBool.Create(true);

    PutJson(FileMatches, JSON);
  finally
    JSON.Free;
  end;
end;

class procedure TDatabase.SetProp(Username: string; Prop, Value: string);
begin
  const JSON = GetAccountJSON(Username);
  try
    const Pair = JSON.Get(Prop);
    if Pair <> nil then
      // Update existing pair
      Pair.JsonValue := TJSONString.Create(Value)
    else
      // Add new pair
      JSON.AddPair(Prop, Value);

    // Write
    PutAccountJSON(Username, JSON);
  finally
    JSON.Free;
  end;
end;

class procedure TDatabase.SetProperty(Username: string; Prop: TAccountProp;
  Value: string);
begin
  SetProp(Username, PropID(Prop), Value);
end;

end.
