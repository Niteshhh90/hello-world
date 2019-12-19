codeunit 50100 "Subscriber Code"
{
    [IntegrationEvent(true, false)]
    procedure OnSendStudentApproval(var StudentDetails: Record "Student Details")
    begin

    end;

    [IntegrationEvent(true, false)]
    procedure OnCancelStudentApprovalRequest(var StudentDetails: Record "Student Details")
    begin

    end;

    local procedure ShowStudentApprovalStatus(StudentDetails: Record "Student Details")
    var
        DocStatusChangeMsg: Label 'Student Roll No.: %1 has been automatically approved. The status has been changed to %2.';
        PendingApprovalMsg: Label 'An approval request has been sent.';

    begin
        StudentDetails.FIND;

        CASE StudentDetails.Status OF
            StudentDetails.Status::Released:
                MESSAGE(DocStatusChangeMsg, StudentDetails."Roll No.", StudentDetails.Status::Released);
            StudentDetails.Status::"Pending Approval":
                IF HasOpenOrPendingApprovalEntries(StudentDetails.RECORDID) THEN
                    MESSAGE(PendingApprovalMsg);
        END;
    end;

    procedure HasOpenOrPendingApprovalEntries(RecordID: RecordID): Boolean
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.SETRANGE("Table ID", RecordID.TABLENO);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecordID);
        ApprovalEntry.SETFILTER(Status, '%1|%2', ApprovalEntry.Status::Open, ApprovalEntry.Status::Created);
        ApprovalEntry.SETRANGE("Related to Change", FALSE);
        EXIT(NOT ApprovalEntry.ISEMPTY);
    end;

    [EventSubscriber(ObjectType::Codeunit, 1535, 'OnAfterIsSufficientApprover', '', false, false)]
    local procedure IsSufficientApprover(UserSetup: Record "User Setup"; ApprovalEntryArgument: Record "Approval Entry"; var IsSufficient: Boolean)
    begin
        IsSufficient := false;
        CASE ApprovalEntryArgument."Table ID" OF
            DATABASE::"Student Details":
                if IsSufficientStudentDetailsApprover(UserSetup, ApprovalEntryArgument."Amount (LCY)") then
                    IsSufficient := true;
        end;
    end;

    local procedure IsSufficientStudentDetailsApprover(UserSetup: Record "User Setup"; ApprovalAmountLCY: Decimal): Boolean
    begin
        IF UserSetup."User ID" = UserSetup."Approver ID" THEN
            EXIT(TRUE);

        IF UserSetup."Unlimited Sales Approval" OR
           ((ApprovalAmountLCY <= UserSetup."Sales Amount Approval Limit") AND (UserSetup."Sales Amount Approval Limit" <> 0))
        THEN
            EXIT(TRUE);

        EXIT(FALSE);
    end;

    procedure IsStudentDetailsPendingApproval(var StudentDetails: Record "Student Details"): Boolean
    begin
        IF StudentDetails.Status <> StudentDetails.Status::Open THEN
            EXIT(FALSE);

        EXIT(IsStudentDetailsApprovalsWorkflowEnabled(StudentDetails));
    end;

    procedure IsStudentDetailsApprovalsWorkflowEnabled(var StudentDetails: Record "Student Details"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(StudentDetails, WorkflowsEventHandling.RunWorkflowOnSendStudentDetailsForApprovalCode));
    end;

    procedure CheckStudentDetailsApprovalPossible(var StudentDetails: Record "Student Details"): Boolean
    var
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
    begin
        IF NOT IsStudentDetailsApprovalsWorkflowEnabled(StudentDetails) THEN
            ERROR(NoWorkflowEnabledErr);

        OnAfterCheckStudentDetailsApprovalPossible(StudentDetails);

        EXIT(TRUE);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckStudentDetailsApprovalPossible(var StudentDetails: Record "Student Details")
    begin
    end;

    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowsEventHandling: Codeunit "Workflows Events";
}