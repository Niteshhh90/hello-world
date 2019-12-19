// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

table 50100 "Student Details"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Roll No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "First Name"; Text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Last Namee"; Text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Address"; Text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Date of Birth"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Class No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Status"; Option)
        {

            DataClassification = ToBeClassified;
            OptionMembers = Open,Released,"Pending Approval";
            OptionCaption = 'Open , Released , "Pending Approval"';

            trigger OnValidate()
            var
                Nametxt: Text;
            begin
                Message('Status Changed to %1', Status);

            end;

        }
    }

    keys
    {
        key(PrimeryKey; "Roll No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure ReleaseStudentDetails(var StudentDetails: Record "Student Details")
    begin
        if StudentDetails.Status = StudentDetails.Status::Released then
            exit;

        StudentDetails.Status := StudentDetails.Status::Released;
        StudentDetails.Modify();
    end;

    procedure OpenStudentDetails(var StudentDetails: Record "Student Details")
    begin
        if StudentDetails.Status = StudentDetails.Status::Open then
            exit;

        StudentDetails.Status := StudentDetails.Status::Open;
        StudentDetails.Modify();
    end;

    procedure SetStatusToPendingApproval(var StudentDetails: Record "Student Details")
    begin
        if StudentDetails.Status = StudentDetails.Status::"Pending Approval" then
            exit;

        StudentDetails.Status := StudentDetails.Status::"Pending Approval";
        StudentDetails.Modify();
    end;

}