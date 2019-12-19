page 50100 "Student Details"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Student Details";
    ContextSensitiveHelpPage = ' My Feature ';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("First Name"; "First Name")
                {
                    ApplicationArea = All;

                }
                field("Last Name"; "Last Name")
                {
                    ApplicationArea = All;

                }
                field(Address; Address)
                {
                    ApplicationArea = All;

                }
                field("Roll No."; "Roll No.")
                {
                    ApplicationArea = All;

                }
                field("Class No."; "Class No.")
                {
                    ApplicationArea = All;

                }
                field("Date of Birth"; "Date of Birth")
                {
                    ApplicationArea = All;

                }
                field(Status; Status)
                {
                    ApplicationArea = All;

                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(Testing)
            {
                ApplicationArea = All;
                RunObject = codeunit 50101;

                trigger OnAction();
                begin
                    Message('Done');
                end;
            }
            action(Approvals)
            {
                AccessByPermission = TableData 454 = R;
                ApplicationArea = Suite;
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category8;
                ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                trigger OnAction()
                var
                    WorkflowsEntriesBuffer: Record "Workflows Entries Buffer";
                begin
                    WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID, DATABASE::"Student Details", 0, Format("Roll No."));
                end;
            }
            action(SendApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send A&pproval Request';
                //Enabled = NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;
                ToolTip = 'Request approval of the document.';

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Subscriber Code";
                begin
                    IF ApprovalsMgmt.CheckStudentDetailsApprovalPossible(Rec) THEN
                        ApprovalsMgmt.OnSendStudentApproval(Rec);
                end;
            }
            action(CancelApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancel Approval Re&quest';
                //Enabled = CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Category9;
                ToolTip = 'Cancel the approval request.';

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Subscriber Code";
                    WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                begin
                    ApprovalsMgmt.OnCancelStudentApprovalRequest(Rec);
                    //WorkflowWebhookMgt.FindAndCancel(RECORDID);
                end;
            }
        }
    }
}