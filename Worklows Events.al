codeunit 50102 "Workflows Events"
{
    procedure RunWorkflowOnSendStudentDetailsForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendStudentDetailsForApproval'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50100, 'OnSendStudentApproval', '', false, false)]
    [Scope('Internal')]
    procedure RunWorkflowOnSendStudentDetailsForApproval(var StudentDetails: Record "Student Details")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendStudentDetailsForApprovalCode, StudentDetails);
    end;

    procedure RunWorkflowOnCancelStudentDetailsForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelStudentDetailsForApproval'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 50100, 'OnCancelStudentApprovalRequest', '', false, false)]
    [Scope('Internal')]
    procedure RunWorkflowOnCancelStudentDetailsForApproval(var StudentDetails: Record "Student Details")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelStudentDetailsForApprovalCode, StudentDetails);
    end;

    [EventSubscriber(ObjectType::Codeunit, 1520, 'OnAddWorkflowEventsToLibrary', '', false, false)]
    [Scope('Internal')]
    procedure CreateEventsLibrary()
    var
        StudentDetailsSendForApprovalEventDescTxt: Label 'Approval of a Student Details is requested.';
        StudentDetailsApprReqCancelledEventDescTxt: Label 'An approval request for a Student Details is canceled.';
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendStudentDetailsForApprovalCode, DATABASE::"Student Details",
        StudentDetailsSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelStudentDetailsForApprovalCode, DATABASE::"Student Details",
        StudentDetailsApprReqCancelledEventDescTxt, 0, FALSE);
    end;

    [EventSubscriber(ObjectType::Codeunit, 1520, 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    [Scope('Internal')]
    procedure AddEventPredecessors(EventFunctionName: Code[128])
    begin
        case EventFunctionName of
            RunWorkflowOnCancelStudentDetailsForApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelStudentDetailsForApprovalCode(), RunWorkflowOnSendStudentDetailsForApprovalCode());
            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode://UPPERCASE('RunWorkflowOnApproveApprovalRequest'):
                WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendStudentDetailsForApprovalCode());
            WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode://UPPERCASE('RunWorkflowOnRejectApprovalRequest'):
                WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendStudentDetailsForApprovalCode());
            WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode://UPPERCASE('RunWorkflowOnDelegateApprovalRequest'):
                WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendStudentDetailsForApprovalCode());

        end;
    end;

    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
}