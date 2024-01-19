Imports Parex.pts.general


Public Class TicketSupport
    Inherits pts_net.templates.PageTemplate

    '' FILTERS
    Dim FilterSearchList As New Parex.pts.general.FilterSearchListforSQL
    Dim FilterStatusSelected As String = "" '' this is hard coded, Open or Closed.  0 or 1
    Protected Property FilterStatusID As Integer = 0
    Dim FilterPrioritySelected As String
    Protected Property FilterPriorityID As Integer = 0
    Dim FilterCategorySelected As String
    Protected Property FilterCategoryID As Integer = 0
    Dim FilterIssueTypeSelected As String
    Protected Property FilterIssueTypeID As Integer = 0
    Dim FilterMethodSelected As String
    Protected Property FilterMethodID As Integer = 0
    Dim FilterProductSelected As String
    Protected Property FilterProductID As Integer = 0



    Dim QS As New System.Text.StringBuilder


    Public Property imagepathname As String
    Public Property uploadticketlocation As String
    Public Property updatedby As String
    Public Property lastupdated As String
    Public Property lastupdateddateformat As String
    Public Property languagecode As String



    '' Make JS vars
    Protected Property WebService As String = ConfigurationManager.AppSettings("WS.InternalService") & "TicketJson.asmx/"
    Protected Property DealerID As Integer
    Protected Property coutryid As Integer
    Protected Property TicketID As Integer
    Protected Property NoResults As Boolean = False

    Protected Property SupportStaff As String
    Shared countryid As Integer = 0
    Public SearchTicketID As Integer = 0

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Me.EnableViewState = True


        If PermissionCheck(Parex.pts.general.Permission.SupportLocal) Then

            updatedby = CurrentUser.UserName
            lastupdated = Parex.pts.general.Functions.ConvertDateToInteger(Now).ToString
            lastupdateddateformat = Functions.ConvertIntegerToDate(lastupdated).ToShortDateString
            languagecode = CurrentUser.LanguageCode
            uploadticketlocation = ConfigurationManager.AppSettings("pathUpload").Replace("\", "\\")
            imagepathname = ConfigurationManager.AppSettings("pathVirtual") & "/_images/"
            DealerID = Request.QueryString("DealerId")
            countryid = Request.QueryString("countryID") '' IIf(CurrentUser.Permission And Parex.pts.general.Permission.SupportGlobal, 0, CurrentUser.Dealer.CountryId)





            If Not Request.QueryString("SearchTicketID") Is Nothing Then
                If CInt(Request.QueryString("SearchTicketID")) Then
                    SearchTicketID = Request.QueryString("SearchTicketID")
                End If
            End If

            Button9.Text = Resx.GetString("buttons.search")

            If Not IsPostBack Then
                NotPostBack()
            Else
                NotPostBack()
            End If


        End If


    End Sub




    Sub NotPostBack()

        FiltersCallQueryString()
        FilterList()
        Dim tic As Tickets

        If SearchTicketID > 0 Then
            tic = New Tickets(SearchTicketID, DealerID)

        Else
            tic = New Tickets(DealerID, True, FilterSearchList)
        End If



        'If Not Request.QueryString("popup") Is Nothing Then
        '    goback.Text = "<a href='javascript:;' onclick='GoBack()' target='_blank' > Go Back </a>"
        'End If



        lb_dealerid.Text = DealerID

        If Not tic.TicketList.Count = 0 Then
            NoResults = False
            lb_noresults.Text = ""
            If Not TicketID > 0 Then
                TicketID = tic.TicketList.SearchResult(0).TicketID
            End If
            repeaterTickets.DataSource = tic.TicketList
            repeaterTickets.DataBind()

        Else
            NoResults = True
            TicketID = False
            lb_noresults.Text = "no results"
        End If
    End Sub


    Public Function LoadCorrectPlusMinus(ByVal index As Integer) As String

        If index = 0 Then
            Return "minus"
        Else
            Return "plus"
        End If
    End Function

    Public Function LoadFullDisplayHeader(ByVal index As Integer, ByVal Ticket As Integer) As String
        If Ticket = TicketID Then
            Return "none"
        Else
            Return "block"
        End If
    End Function

    Public Function TicketExpired(ByVal Expired As Boolean) As String
        If Expired Then
            Return "color:red"
        Else
            Return ""
        End If
    End Function

    Public Function LoadFullDisplayBody(ByVal index As Integer, ByVal Ticket As Integer) As String
        If Ticket = TicketID Then
            Return "block"
        Else
            If index = 0 Then
                Return "block"
            Else
                Return "none"
            End If
        End If
    End Function

    Public Function Loadopenorclosedimage(ByVal closed As Boolean) As String
        If closed Then
            Return "checkboxclose.png"
        Else
            Return "checkboxopen.png"
        End If
    End Function

    Public Function updateticketstatustitle(ByVal closed As Boolean) As String
        If closed Then
            Return "This ticket is closed"
        Else
            Return "This ticket is open"
        End If
    End Function

    'Public Sub SupportStaffList()



    '    Dim Support As New Parex.pts.general.Support
    '    Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer
    '    Dim countryid As Integer = IIf(CurrentUser.Permission And Parex.pts.general.Permission.SupportGlobal, 0, CurrentUser.Dealer.CountryId)

    '    ''  Dim contactslist As ArrayList = Support.ContactPersons(countryid)
    '    Try

    '    Catch ex As Exception
    '        Parex.pts.errorHandling.WriteErrorInLog(DealerID, "SupportStaffList: " & ex.Message)
    '    End Try

    '    ' Dim ft As New TicketFilters
    '    ''   SupportStaff = serializer.Serialize(ft.Categor

    'End Sub

    Private Sub repeaterTickets_ItemDataBound(sender As Object, e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles repeaterTickets.ItemDataBound
    End Sub


#Region "  JSON  "

    Public Shared Function JsonCategory() As String
        Dim Support As New Parex.pts.general.Support
        Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer
        Dim js As New TicketFilters
        Return serializer.Serialize(js.Category)
    End Function

    Public Shared Function JsonPriority() As String
        Dim Support As New Parex.pts.general.Support
        Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer
        Dim js As New TicketFilters
        Return serializer.Serialize(js.Priority)
    End Function

    Public Shared Function JsonProduct() As String
        Dim Support As New Parex.pts.general.Support
        Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer
        Dim js As New TicketFilters
        Return serializer.Serialize(js.Product)
    End Function

    Public Shared Function JsonMethod() As String
        Dim Support As New Parex.pts.general.Support
        Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer
        Dim js As New TicketFilters
        Return serializer.Serialize(js.Method)
    End Function

    Public Shared Function JsonIssueType() As String
        Dim Support As New Parex.pts.general.Support
        Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer
        Dim js As New TicketFilters
        Return serializer.Serialize(js.IssueType)
    End Function

    Public Shared Function JsonContacts() As String
        Dim Support As New Parex.pts.general.Support
        Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer
        Dim contactslist As ArrayList = Support.ContactPersons(countryid)
        Return serializer.Serialize(contactslist)
    End Function

#End Region

#Region "  Filter  "

    Sub FiltersCallQueryString()

        If Not Request.QueryString("TicketId") Is Nothing Then
        End If

        If Not Request.QueryString("selectedcat") Is Nothing Then
            If Not Request.QueryString("selectedcat") = "" Then
                FilterCategorySelected = Request.QueryString("selectedcat")
                Try
                    Dim CatergoryID As Parex.pts.general.FilterCategory = Parex.pts.general.[Global].FilterList.Category.Find(AddressOf FindCategoryID)
                    FilterSearchList.CategoryID = CatergoryID.myCategoryID
                    FilterCategoryID = CatergoryID.myCategoryID
                Catch ex As Exception
                    Parex.pts.errorHandling.WriteErrorInLog(DealerID, "selectedcat fail : " & ex.Message)
                End Try


            End If
        End If
        If Not Request.QueryString("selectedissuetype") = "" Then
            If Not Request.QueryString("selectedissuetype") = "" Then
                FilterIssueTypeSelected = Request.QueryString("selectedissuetype")
                Try
                    Dim IssueTypeID As Parex.pts.general.FilterIssueType = Parex.pts.general.[Global].FilterList.IssueType.Find(AddressOf FindIssueTypeID)
                    FilterSearchList.IssueTypeID = IssueTypeID.myIssueTypeID
                    FilterIssueTypeID = IssueTypeID.myIssueTypeID
                Catch ex As Exception
                    Parex.pts.errorHandling.WriteErrorInLog(DealerID, "selectedissuetype fail : " & ex.Message)
                End Try

            End If
        End If

        If Not Request.QueryString("selectedmethod") Is Nothing Then
            If Not Request.QueryString("selectedmethod") = "" Then
                FilterMethodSelected = Request.QueryString("selectedmethod")
                Try
                    Dim MethodID As Parex.pts.general.FilterMethod = Parex.pts.general.[Global].FilterList.Method.Find(AddressOf FindMethodID)
                    FilterSearchList.MethodID = MethodID.myMethodID
                    FilterMethodID = MethodID.myMethodID
                Catch ex As Exception
                    Parex.pts.errorHandling.WriteErrorInLog(DealerID, "selectedmethod fail : " & ex.Message)
                End Try

            End If
        End If


        If Not Request.QueryString("selectedpriority") Is Nothing Then
            If Not Request.QueryString("selectedpriority") = "" Then
                FilterPrioritySelected = Request.QueryString("selectedpriority")
                Try
                    Dim PriorityID As Parex.pts.general.FilterPriority = Parex.pts.general.[Global].FilterList.Priority.Find(AddressOf FindPriorityID)
                    FilterSearchList.PriorityID = PriorityID.myPriorityID
                    FilterPriorityID = PriorityID.myPriorityID
                Catch ex As Exception
                    Parex.pts.errorHandling.WriteErrorInLog(DealerID, "selectedpriority fail : " & ex.Message)
                End Try

            End If
        End If

        If Not Request.QueryString("selectedproduct") Is Nothing Then
            If Not Request.QueryString("selectedproduct") = "" Then
                FilterProductSelected = Request.QueryString("selectedproduct")
                Try
                    Dim ProductID As Parex.pts.general.FilterProduct = Parex.pts.general.[Global].FilterList.Product.Find(AddressOf FindProductID)
                    FilterSearchList.ProductID = ProductID.myProductID
                    FilterProductID = ProductID.myProductID
                Catch ex As Exception
                    Parex.pts.errorHandling.WriteErrorInLog(DealerID, "selectedproduct fail : " & ex.Message)
                End Try

            End If
        End If

        If Not Request.QueryString("selectedstatus") Is Nothing Then
            If Not Request.QueryString("selectedstatus") = "" Then
                FilterStatusSelected = Request.QueryString("selectedstatus")
                Try
                    Dim StatusID As Parex.pts.general.FilterStatus = Parex.pts.general.[Global].FilterList.Status.Find(AddressOf FindStatusID)
                    FilterSearchList.StatusID = StatusID.myStatusID
                    FilterStatusID = StatusID.myStatusID
                Catch ex As Exception
                    Parex.pts.errorHandling.WriteErrorInLog(DealerID, "selectedstatus fail : " & ex.Message)
                End Try

            Else
                FilterSearchList.StatusID = 2
                FilterStatusID = 2
            End If
        Else
            FilterSearchList.StatusID = 2
            FilterStatusID = 2
        End If


    End Sub

    Sub FilterList()


        Try


            Dim sb As New System.Text.StringBuilder


            sb.Append("<li><a href=""#"" onclick=""hidefilter('selectedstatus')""  >Filter By: Open/Closed</a>")
            sb.Append("<ul class=""sub_menu"">")
            For Each itemstatus As Parex.pts.general.FilterStatus In Parex.pts.general.[Global].FilterList.Status
                sb.Append("<li><a href=""#"" onclick=""showfilter('selectedstatus', '" & itemstatus.myStatus & "')"">" & itemstatus.myStatus & "</a></li>")
            Next
            sb.Append("</ul>")
            sb.Append("<div   id=""selectedstatus"" style=""text-align:center; clear:both; font-size:12px; color:#0083c5 ; position:relative;  background-color:white "">" & FilterStatusSelected & "</div>")
            sb.Append("</li>")


            sb.Append("<li><a href=""#"" onclick=""hidefilter('selectedcat')"" >By: Category</a>")
            sb.Append("<ul class=""sub_menu"">")
            For Each itemCategory As Parex.pts.general.FilterCategory In Parex.pts.general.[Global].FilterList.Category
                sb.Append("<li><a href=""#"" onclick=""showfilter('selectedcat', '" & itemCategory.myCategory & "')"">" & itemCategory.myCategory & "</a></li>")
            Next
            sb.Append("</ul>")
            sb.Append("<div id=""selectedcat"" style=""text-align:center; clear:both; font-size:12px; color:#0083c5 ; position:relative;  background-color:white "">" & FilterCategorySelected & "</div>")
            sb.Append("</li>")


            sb.Append("<li><a href=""#"" onclick=""hidefilter('selectedissuetype')"" >By: IssueType</a>")
            sb.Append("<ul class=""sub_menu"">")
            For Each itemIssueType As Parex.pts.general.FilterIssueType In Parex.pts.general.[Global].FilterList.IssueType
                sb.Append("<li><a href=""#"" onclick=""showfilter('selectedissuetype', '" & itemIssueType.myIssueType & "')"">" & itemIssueType.myIssueType & "</a></li>")
            Next
            sb.Append("</ul>")
            sb.Append("<div id=""selectedissuetype"" style=""text-align:center; clear:both; font-size:12px; color:#0083c5 ; position:relative;  background-color:white "">" & FilterIssueTypeSelected & "</div>")
            sb.Append("</li>")


            sb.Append("<li><a href=""#"" onclick=""hidefilter('selectedmethod')"" >By: Method</a>")
            sb.Append("<ul class=""sub_menu"">")
            For Each itemMethod As Parex.pts.general.FilterMethod In Parex.pts.general.[Global].FilterList.Method
                sb.Append("<li><a href=""#"" onclick=""showfilter('selectedmethod', '" & itemMethod.myMethod & "')"">" & itemMethod.myMethod & "</a></li>")
            Next
            sb.Append("</ul>")
            sb.Append("<div id=""selectedmethod"" style=""text-align:center; clear:both; font-size:12px; color:#0083c5 ; position:relative;  background-color:white "">" & FilterMethodSelected & "</div>")
            sb.Append("</li>")


            sb.Append("<li><a href=""#"" onclick=""hidefilter('selectedpriority')"" >By: Priority</a>")
            sb.Append("<ul class=""sub_menu"">")
            For Each itemPriority As Parex.pts.general.FilterPriority In Parex.pts.general.[Global].FilterList.Priority
                sb.Append("<li><a href=""#"" onclick=""showfilter('selectedpriority', '" & itemPriority.myPriority & "')"">" & itemPriority.myPriority & "</a></li>")
            Next
            sb.Append("</ul>")
            sb.Append("<div id=""selectedpriority"" style=""text-align:center; clear:both; font-size:12px; color:#0083c5 ; position:relative;  background-color:white "">" & FilterPrioritySelected & "</div>")
            sb.Append("</li>")


            sb.Append("<li><a href=""#"" onclick=""hidefilter('selectedproduct')"" >By: Product</a>")
            sb.Append("<ul class=""sub_menu"">")
            For Each itemProduct As Parex.pts.general.FilterProduct In Parex.pts.general.[Global].FilterList.Product
                sb.Append("<li><a href=""#"" onclick=""showfilter('selectedproduct', '" & itemProduct.myProduct & "')"">" & itemProduct.myProduct & "</a></li>")
            Next
            sb.Append("</ul>")
            sb.Append("<div id=""selectedproduct"" style=""text-align:center; clear:both; font-size:12px; color:#0083c5 ; position:relative;  background-color:white "">" & FilterProductSelected & "</div>")
            sb.Append("</li>")
            filtermenu.Text = sb.ToString()


        Catch ex As Exception
            Parex.pts.errorHandling.WriteErrorInLog(DealerID, "Filter Create Fail: " & ex.Message)
        End Try

    End Sub


    Private Function FindStatusID(ByVal Status As FilterStatus) As Boolean
        If Status.myStatus = FilterStatusSelected Then
            Return True
        Else
            Return False
        End If
    End Function
    Private Function FindProductID(ByVal Product As FilterProduct) As Boolean
        If Product.myProduct = FilterProductSelected Then
            Return True
        Else
            Return False
        End If
    End Function
    Private Function FindMethodID(ByVal Method As FilterMethod) As Boolean
        If Method.myMethod = FilterMethodSelected Then
            Return True
        Else
            Return False
        End If
    End Function
    Private Function FindPriorityID(ByVal Priority As FilterPriority) As Boolean
        If Priority.myPriority = FilterPrioritySelected Then
            Return True
        Else
            Return False
        End If
    End Function
    Private Function FindIssueTypeID(ByVal IssueType As FilterIssueType) As Boolean
        If IssueType.myIssueType = FilterIssueTypeSelected Then
            Return True
        Else
            Return False
        End If
    End Function
    Private Function FindCategoryID(ByVal Category As FilterCategory) As Boolean
        If Category.myCategory = FilterCategorySelected Then
            Return True
        Else
            Return False
        End If
    End Function

#End Region






End Class