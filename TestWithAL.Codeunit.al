codeunit 50101 "Test With AL"
{

    trigger OnRun()
    begin
        MESSAGE(Text00001);
    end;

    var
        Text00001: TextConst ENU = 'Testing';
}