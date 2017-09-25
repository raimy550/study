unit YuYueInfo;

interface
uses
  BaseInfo,
  Windows,
  Messages,
  Dialogs,
  Controls,
  StdCtrls,
  Utils,
  SysUtils,
  Classes,
  Contnrs,
  cxCheckBox,
  StrMap,
  StrUtils,
  uLkJSON;

  const
    cntYuYueTxt: string = '�ͻ�ԤԼ';
    cntYuYueCls: string = 'Tbs';
type
  CYuYueInfo = class(CBaseInfo)
  private
    procedure HandleDataKehuInfo(h: HWND);
    procedure HandleDataYuYueDanInfo(h: HWND);
    procedure AddDataKehuInfo(h: HWND);
    procedure AddDataYuYueDanInfo(h: HWND);
  protected
    procedure Init();override;
    function HandleData(h: HWND): Boolean;override;
  public
    procedure SaveJsonData();override;
    procedure SaveShowData();
    function UpdateOp(h: HWND): Boolean;override;

  end;

implementation
procedure CYuYueInfo.Init;
   begin
     //�ͻ�/������Ϣ
     ShowInfo.Put('0', 'ԤԼ��');
     ShowInfo.Put('1', 'VIN');
     ShowInfo.Put('2', '��������');
     ShowInfo.Put('3', '�ϴν�������');
     ShowInfo.Put('6', '��ϵ');
     ShowInfo.Put('7', '����');
     ShowInfo.Put('8', '��������');
     ShowInfo.Put('9', 'ԤԼ���ֻ�');
     ShowInfo.Put('10', '����');
     ShowInfo.Put('12', 'ԤԼ�˵绰����');
     ShowInfo.Put('13', 'ԤԼ�˵绰����');
     ShowInfo.Put('14', '���ƺ���');
     ShowInfo.Put('15', '���ƹ�����');
     ShowInfo.Put('16', '����������');
     ShowInfo.Put('18', '���������');
     ShowInfo.Put('19', 'ר���������');
     //ԤԼ��������Ϣ 100+
     ShowInfo.Put('100', 'ԤԼ����');
     ShowInfo.Put('102', 'ԤԼ����');
     ShowInfo.Put('103', 'ԤԼ����');
     ShowInfo.Put('104', 'ԤԼҵ������');
     ShowInfo.Put('106', 'ҵ��������');
     ShowInfo.Put('107', 'ԤԼ����ʱ��');
     ShowInfo.Put('108', '�������');
     ShowInfo.Put('109', 'Ԥ�ƽӴ�ʱ��');
     ShowInfo.Put('110', 'Ԥ���Ϲ�λʱ��');
     ShowInfo.Put('111', 'ԤԼ���');
     ShowInfo.Put('112', 'ԤԼ��λ');
     ShowInfo.Put('113', 'ԤԼʩ��ʱ��');
     ShowInfo.Put('114', 'Ԥ�ƽ������');
     ShowInfo.Put('116', '�ӳ���ַ');
     ShowInfo.Put('117', '��������');
     ShowInfo.Put('118', '������');
     ShowInfo.Put('119', 'ԤԼ����');
     ShowInfo.Put('120', '��ע');
     ShowInfo.Put('122', 'ԤԼ��ʦ');
     ShowInfo.Put('130', '�ͳ���ַ');
   end;

   function CYuYueInfo.HandleData(h: HWND): Boolean;
   var
    buf: array[0..255] of Char;
    nRet, nRet1: Integer;
    tcl: TWinControl;
   begin
      Result := False;
      if Utils.FilterControls(h)=False then
       Exit;

       Result := True;
       if Utils.ControlTextContains(h, '������Ϣ') then
       begin
          //ShowMessageFmt('%s', ['�ͻ�������Ϣ---��ʼ']);
          HandleDataKehuInfo(h);
          //ShowMessageFmt('%s', ['�ͻ�������Ϣ---����']);
       end
       else if Utils.ControlTextContains(h, 'ԤԼ��������Ϣ')  then
       begin
         //ShowMessageFmt('%s', ['ԤԼ��������Ϣ---��ʼ']);
         HandleDataYuYueDanInfo(h);
         //ShowMessageFmt('%s', ['ԤԼ��������Ϣ---����']);
       end
       else
        Result := False;
   end;

   procedure CYuYueInfo.HandleDataKehuInfo(h: HWND);
   begin
    AddDataKehuInfo(h);
    h := GetWindow(h, GW_CHILD);
    while h <> 0 do
    begin
      HandleDataKehuInfo(h);
      h := GetWindow(h, GW_HWNDNEXT);
    end;
   end;

   procedure CYuYueInfo.HandleDataYuYueDanInfo(h: HWND);
   begin
    AddDataYuYueDanInfo(h);
    h := GetWindow(h, GW_CHILD);
    while h <> 0 do
    begin
      HandleDataYuYueDanInfo(h);
      h := GetWindow(h, GW_HWNDNEXT);
    end;
   end;

   procedure CYuYueInfo.AddDataKehuInfo(h: HWND);
   var
    buf: array[0..255] of Char;
    tab: Integer;
    tcl: TWinControl;
   begin
      if Utils.FilterControls(h)=False then
      Exit;

      tcl := Utils.GetInstanceFromhWnd(h);
      if tcl.Visible then
      begin
        tcl.GetTextBuf(buf, 255);
        tab :=  tcl.TabOrder;
        
        if Utils.ControlTextContains(h, '�ͻ�/������Ϣ') then
         Exit;

        AddData(tab, buf); 
      end;

   end;

   procedure CYuYueInfo.AddDataYuYueDanInfo(h: HWND);
   var
    buf: array[0..255] of Char;
    tab: Integer;
    tcl: TWinControl;
   begin
      if Utils.FilterControls(h)=False then
      Exit;

      tcl := Utils.GetInstanceFromhWnd(h);
      if tcl.Visible then
      begin
        tcl.GetTextBuf(buf, 255);
        tab :=  tcl.TabOrder+100;
        
        if Utils.ControlTextContains(h, 'ԤԼ��������Ϣ') then
         Exit;

        AddData(tab, buf); 
      end;

   end;

procedure CYuYueInfo.SaveShowData();
var
  i,nCount, tmp, tmp1: Integer;
  s,  FileName: string;
begin
   SortData(ShowDataMap);
   nCount := ShowDataMap.Count;
   s := Concat(s,  Char(13), Char(10), '���ͻ�������Ϣ��', Char(13), Char(10));
   for i:=0 to nCount-1 do
   begin
     if i>0 then
     begin
       tmp := StrToInt(ShowDataMap.FKeyList[i]);
       tmp1 := StrToInt(ShowDataMap.FKeyList[i-1]);
       if ((tmp1<100) and (tmp>=100)) then
        s := Concat(s, Char(13), Char(10),'��ԤԼ��������Ϣ��', Char(13), Char(10));
     end;

   s := Concat(s, ShowDataMap.FStrList[i], Char(13), Char(10));
   end;

   FileName := Utils.GetSaveDir()+Utils.cntSaveYuYueForShowName;
   Utils.SaveData(FileName, s, False);
   //ShowMessageFmt('%s%s%s', ['��Ϣ��ȡ�ɹ�,', '����·����', FileName]);
end;

procedure CYuYueInfo.SaveJsonData();
var
  i,nCount, cur, pre: Integer;
  s, FileName: string;
  jsBase,js: TlkJSONobject;
begin
   SortData(ShowDataMap);
   nCount := ShowDataMap.Count;

   jsBase := TlkJSONobject.Create(True);
   js:=TlkJSONobject.Create(True);
   jsBase.Add('�ͻ�������Ϣ', js);
   for i:=0 to nCount-1 do
   begin
     cur := i;
     if i>0 then
     begin
       cur := StrToInt(ShowDataMap.FKeyList[i]);
       pre := StrToInt(ShowDataMap.FKeyList[i-1]);
       if ((pre<100) and (cur>=100)) then
       begin
           js:=TlkJSONobject.Create(True);
           jsBase.Add('ԤԼ��������Ϣ', js);
       end;
     end;

     js.Add(GetKeyByTab(cur), PtlDataMap.Get(IntToStr(cur)));
   end;

   FileName := Utils.GetSaveDir()+Utils.cntSaveYuYueName;
   TlkJSONstreamed.SaveToFile(jsBase, FileName);
   //ShowMessageFmt('%s%s%s', ['��Ϣ��ȡ�ɹ�,', '����·����', FileName]);
end;

function CYuYueInfo.UpdateOp(h: HWND): Boolean;
begin
  //WndOp := Utils.FindeWindowBy(h, cntYuYueTxt, cntYuYueCls);
  Result := False;
  if Utils.ClassNameContains(h, cntYuYueCls) and Utils.ControlTextContains(h, cntYuYueTxt) then
  begin
       WndOp := Utils.FindeWindowBy(h, Utils.cntOpSave, cntOpSaveCls);
       Result := True;
  end;
end;

end.