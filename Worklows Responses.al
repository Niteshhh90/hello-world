codeunit 50103 "Workflows Responses"
{
    [EventSubscriber(ObjectType::Codeunit, 1521, 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    [Scope('Internal')]
    local procedure AddResponsePredecessors(ResponseFunctionName: Code[128])
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowsEventHandling: Codeunit "Workflows Events";
    begin
        CASE ResponseFunctionName OF
            WorkflowResponseHandling.SetStatusToPendingApprovalCode:
                BEGIN
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowsEventHandling.RunWorkflowOnSendStudentDetailsForApprovalCode);
                END;
            WorkflowResponseHandling.CreateApprovalRequestsCode:
                BEGIN
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowsEventHandling.RunWorkflowOnSendStudentDetailsForApprovalCode);
                END;
            WorkflowResponseHandling.SendApprovalRequestForApprovalCode:
                BEGIN
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowsEventHandling.RunWorkflowOnSendStudentDetailsForApprovalCode);
                END;
            WorkflowResponseHandling.OpenDocumentCode:
                BEGIN
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowsEventHandling.RunWorkflowOnCancelStudentDetailsForApprovalCode);
                END;
            WorkflowResponseHandling.CancelAllApprovalRequestsCode:
                BEGIN
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowsEventHandling.RunWorkflowOnCancelStudentDetailsForApprovalCode);
                END;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, 1521, 'OnReleaseDocument', '', false, false)]
    [Scope('Internal')]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        StudentDetails: Record "Student Details";
        Varient: Variant;
    begin
        Varient := RecRef;
        CASE RecRef.NUMBER OF
            DATABASE::"Student Details":
                begin
                    StudentDetails.ReleaseStudentDetails(Varient);
                    Handled := true;
                end;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, 1521, 'OnOpenDocument', '', false, false)]
    [Scope('Internal')]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        StudentDetails: Record "Student Details";
        Varient: Variant;
    begin
        Varient := RecRef;
        CASE RecRef.NUMBER OF
            DATABASE::"Student Details":
                begin
                    StudentDetails.OpenStudentDetails(Varient);
                    Handled := true;
                end;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, 1535, 'OnSetStatusToPendingApproval', '', false, false)]
    [Scope('Internal')]
    local procedure SetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        StudentDetails: Record "Student Details";

    begin
        CASE RecRef.NUMBER OF
            DATABASE::"Student Details":
                begin
                    StudentDetails.SetStatusToPendingApproval(Variant);
                    IsHandled := true;
                end;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, 1502, 'OnAfterInsertApprovalsTableRelations', '', false, false)]
    [Scope('Internal')]
    local procedure CreateWorkflowTableRelation()
    var
        StudentDetails: Record "Student Details";
        WorkflowSetup: Codeunit "Workflow Setup";
        ApprovalEntry: Record "Approval Entry";

    begin
        WorkflowSetup.InsertTableRelation(DATABASE::"Student Details", 0,
          DATABASE::"Approval Entry", ApprovalEntry.FIELDNO("Record ID to Approve"));
    end;

    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
}