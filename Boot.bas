Attribute VB_Name = "Boot"
Option Explicit

' Reconstructed VB6 source shell generated from decompiled output.
' Source reference: /opt/git/AlphaSeries_cracked/DECOMPILED/Boot.bas
' Decompiled procedure bodies are intentionally not copied until they are understood and made valid VB6.

' Original declaration: Private Sub Proc_1_0_6BA9D0
Public Function Proc_1_0_6BA9D0(ParamArray args() As Variant) As Variant
    Dim chanceRows() As String
    Dim productRows() As String
    Dim chanceIndex As Long
    Dim productIndex As Long
    Dim chanceValue As Long
    Dim productId As Long
    Dim productCount As Long
    Dim productList As String
    Dim groupPayload As String

    On Error GoTo BuildFailed

    global_0082912C = vbNullString
    global_00829168 = 0
    ReDim global_00829140(0 To 49)
    ReDim global_0082915C(0 To 49)

    chanceRows = Split(CStr(Proc_5_2_6D4690("SELECT chance FROM settings_recycler GROUP BY settings_recycler.chance ORDER BY settings_recycler.chance DESC LIMIT 50", 0, 0)), Chr$(13))
    For chanceIndex = LBound(chanceRows) To UBound(chanceRows)
        If global_00829168 > 49 Then Exit For
        If Len(chanceRows(chanceIndex)) > 0 Then
            chanceValue = CInt(Val(CStr(chanceRows(chanceIndex))))
            global_0082915C(global_00829168) = chanceValue
            global_00829140(global_00829168) = vbNullString

            productCount = 0
            productList = vbNullString
            groupPayload = vbNullString
            productRows = Split(CStr(Proc_5_2_6D4690("SELECT id_product FROM settings_recycler WHERE chance='" & CStr(chanceValue) & "' LIMIT 100", 0, 0)), Chr$(13))
            For productIndex = LBound(productRows) To UBound(productRows)
                If Len(productRows(productIndex)) > 0 Then
                    productId = CLng(Val(CStr(productRows(productIndex))))
                    If productId > 0 Then
                        productList = productList & CStr(productId) & Chr$(2)
                        groupPayload = groupPayload & CStr(Proc_3_0_6D2AF0(productId, Empty, vbNullString))
                        productCount = productCount + 1
                    End If
                End If
            Next productIndex

            global_00829140(global_00829168) = productList
            global_0082912C = global_0082912C & CStr(Proc_3_0_6D2AF0(chanceValue, Empty, vbNullString))
            global_0082912C = global_0082912C & CStr(Proc_3_0_6D2AF0(productCount, Empty, vbNullString)) & groupPayload
            global_00829168 = global_00829168 + 1
        End If
    Next chanceIndex

    global_0082912C = CStr(Proc_3_0_6D2AF0(global_00829168, Empty, vbNullString)) & global_0082912C

BuildFailed:
    Proc_1_0_6BA9D0 = Empty
End Function

' Original declaration: Private Sub Proc_1_1_6BB340
Public Function Proc_1_1_6BB340(ParamArray args() As Variant) As Variant
    Dim productQuery As String
    Dim catalogQuery As String
    Dim maxProductId As Long
    Dim maxCatalogId As Long

    On Error GoTo BuildFailed

    maxProductId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT MAX(id) FROM products", 0, 0))))
    If maxProductId < 0 Then maxProductId = 0
    ReDim global_008292BC(0 To maxProductId)

    productQuery = "SELECT id,id_type,action,NULL,NULL,default_sign,status_max,handitems,distance_allowed,is_tradeable,is_recycleable,is_signable,default_sign,min_roomrights,name,description,NULL,NULL,sprite,is_iconstack,id_deco,time_rent,square_x,square_y,square_z,NULL,effect,receive_badge,wire,id_counter,square_rotation,status_walkon,status_walkoff,NULL,has_charge,charge_price_credits,charge_price_activitypoints,charge_price_activitypoints_type,charge_size,NULL,is_marketofferable,is_badgeshop FROM products ORDER BY id ASC"
    CacheRowsById global_008292BC, CStr(Proc_5_2_6D4690(productQuery, 0, 0))

    maxCatalogId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT MAX(id) FROM catalog_products", 0, 0))))
    If maxCatalogId < 0 Then maxCatalogId = 0
    ReDim global_008292C0(0 To maxCatalogId)

    catalogQuery = "SELECT id,sprite,id_product,ctlg_pageid,type_secondary,amount,receive_badge,price_credits,price_activitypoints,type_activitypoints,allow_gifts,min_hc_level_required,replace_defaultsign FROM catalog_products ORDER BY id ASC"
    CacheRowsById global_008292C0, CStr(Proc_5_2_6D4690(catalogQuery, 0, 0))

    global_00829258 = vbCr & CStr(Proc_5_2_6D4690("SELECT id,items FROM products_deals ORDER BY id ASC", Chr$(13), 0)) & Chr$(13)
    global_0082916C = CLng(Val(CStr(Proc_5_2_6D4690("SELECT id FROM products WHERE sprite='ecotron_box' LIMIT 1", 0, 0))))

    Proc_1_17_6CCDC0 0, 0, 0
    Proc_1_15_6CA000 0, 0, 0
    Proc_7_0_8034A0 "Fy"
    Proc_1_18_6CE9C0 0, 0, 0

    global_008290A0 = Replace(CStr(Proc_5_2_6D4690("SELECT id FROM products WHERE id_counter IS NOT NULL", 0, 0)), Chr$(13), Chr$(9), 1, -1, vbBinaryCompare)
    global_008290A4 = CLng(Val(CStr(Proc_5_2_6D4690("SELECT id FROM products WHERE id_type='11' LIMIT 1", 0, 0))))
    global_008290A8 = CLng(Val(CStr(Proc_5_2_6D4690("SELECT id FROM products WHERE id_type='19' LIMIT 1", 0, 0))))

    Proc_1_13_6C9820 0, 0, 0
    BuildCampaignReplacementCache
    Proc_1_0_6BA9D0 0, 0, 0

    global_00829078 = CStr(Proc_5_2_6D4690("SELECT id_product,type_secondary,id_contain,type_check FROM packages", 0, 0))
    global_0082907C = CStr(Proc_5_2_6D4690("SELECT id,id_pet,id_race,color FROM packages_pets", 0, 0))
    global_00829084 = vbCr & CStr(Proc_5_2_6D4690("SELECT id_product,months,level FROM products_containshc", Chr$(13), 0)) & Chr$(13)

BuildFailed:
    Proc_1_1_6BB340 = Empty
End Function

' Original declaration: Private Sub Proc_1_2_6BE280
Public Function Proc_1_2_6BE280(ParamArray args() As Variant) As Variant
    Dim treeRows() As String
    Dim treeIndex As Long
    Dim treeId As Long
    Dim cacheIndex As Long
    Dim roomRows As String

    On Error GoTo BuildFailed

    global_00829128 = 0
    ReDim global_0082911C(0 To 99)

    treeRows = Split(CStr(Proc_5_2_6D4690("SELECT id_tree FROM rooms_recommented GROUP BY id_tree", 0, 0)), Chr$(13))
    For treeIndex = LBound(treeRows) To UBound(treeRows)
        treeId = CLng(Val(CStr(treeRows(treeIndex))))
        If treeId <> 0 Then
            cacheIndex = global_00829128
            If cacheIndex > 99 Then Exit For

            roomRows = CStr(Proc_5_2_6D4690(BuildRecommendedRoomsQuery(treeId), 0, 0))
            global_0082911C(cacheIndex) = CStr(Proc_3_0_6D2AF0(treeId, Empty, vbNullString)) & BuildRecommendedRoomsPayload(roomRows)
            global_00829128 = global_00829128 + 1
        End If
    Next treeIndex

    If global_00829128 = 0 Then
        global_0082911C = CStr(Proc_3_0_6D2AF0(0, Empty, vbNullString))
    End If

    Proc_1_2_6BE280 = Empty
    Exit Function

BuildFailed:
    Proc_1_2_6BE280 = Empty
End Function

' Original declaration: Private Sub Proc_1_3_6BEBA0
Public Function Proc_1_3_6BEBA0(ParamArray args() As Variant) As Variant
    ' TODO: Reconstruct behavior from decompiled reference.
    Proc_1_3_6BEBA0 = Empty
End Function

' Original declaration: Private Sub Proc_1_4_6C4F00
Public Function Proc_1_4_6C4F00(ParamArray args() As Variant) As Variant
    On Error GoTo BootStepFailed
    Proc_1_8_6C6850 0, 0, 0
    Proc_1_9_6C6DF0 0, 0, 0
    Proc_1_19_6CF190 0, 0, 0
    Proc_1_20_6CF830 0, 0, 0
    Proc_1_21_6D08C0 0, 0, 0
    Proc_1_22_6D0F00 0, 0, 0
    Proc_1_11_6C8D10 0, 0, 0
    Proc_1_12_6C8EF0 0, 0, 0
    Proc_1_2_6BE280 0

BootStepFailed:
    Proc_1_4_6C4F00 = Empty
End Function

' Original declaration: Private Sub Proc_1_5_6C4F80
Public Function Proc_1_5_6C4F80(ParamArray args() As Variant) As Variant
    On Error GoTo BuildFailed

    BuildAchievementSettingsCache
    Proc_1_9_6C6DF0 0, 0, 0
    Proc_1_4_6C4F00 0, 0, 0
    Proc_1_7_6C5E10 0, 0, 0
    Proc_1_18_6CE9C0 0, 0, 0
    Proc_1_16_6CCA60 0, 0, 0
    Proc_1_6_6C5830 0, 0, 0
    Proc_1_10_6C7690 0, 0, 0
    Proc_1_19_6CF190 0, 0, 0
    Proc_1_20_6CF830 0, 0, 0
    Proc_1_21_6D08C0 0, 0, 0
    Proc_1_13_6C9820 0, 0, 0
    Proc_1_22_6D0F00 0, 0, 0
    BuildChatSettingsCache
    BuildMessengerFriendLimitCache

BuildFailed:
    Proc_1_5_6C4F80 = Empty
End Function

' Original declaration: Private Sub Proc_1_6_6C5830
Public Function Proc_1_6_6C5830(ParamArray args() As Variant) As Variant
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long

    On Error GoTo BuildFailed
    global_008291EC = vbNullString

    rows = Split(CStr(Proc_5_2_6D4690("SELECT product_pet,id_pet,breed,min_rank,min_hcrank,name FROM settings_petraces", 0, 0)), Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 5 Then
                global_008291EC = global_008291EC & "[" & CStr(fields(0)) & Chr$(9)
                global_008291EC = global_008291EC & CStr(Val(CStr(fields(1)))) & Chr$(9)
                global_008291EC = global_008291EC & CStr(Val(CStr(fields(2)))) & Chr$(9)
                global_008291EC = global_008291EC & CStr(Val(CStr(fields(3)))) & Chr$(9)
                global_008291EC = global_008291EC & CStr(Val(CStr(fields(4)))) & Chr$(9)
                global_008291EC = global_008291EC & CStr(fields(5)) & "]"
            End If
        End If
    Next rowIndex

BuildFailed:
    Proc_1_6_6C5830 = Empty
End Function

' Original declaration: Private Sub Proc_1_7_6C5E10
Public Function Proc_1_7_6C5E10(ParamArray args() As Variant) As Variant
    Dim maxLevelId As Long
    Dim maxCommandId As Long
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim cacheIndex As Long

    On Error GoTo BuildFailed

    maxLevelId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT MAX(id_level) FROM bots_petlevels", 0, 0))))
    If maxLevelId < 0 Then maxLevelId = 0
    ReDim global_008292D0(0 To maxLevelId)

    rows = Split(CStr(Proc_5_2_6D4690("SELECT id_level,max_energy,max_exp,max_nutrition FROM bots_petlevels ORDER BY id_level ASC", 0, 0)), Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 3 Then
                cacheIndex = CLng(Val(CStr(fields(0))))
                If cacheIndex >= LBound(global_008292D0) And cacheIndex <= UBound(global_008292D0) Then
                    global_008292D0(cacheIndex) = CStr(Val(CStr(fields(1)))) & Chr$(9) & CStr(Val(CStr(fields(2)))) & Chr$(9) & CStr(Val(CStr(fields(3))))
                End If
            End If
        End If
    Next rowIndex

    global_008292C8 = CLng(Val(CStr(Proc_5_2_6D4690("SELECT COUNT(id_command) FROM bots_petcommands", 0, 0))))
    maxCommandId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT MAX(id_command) FROM bots_petcommands", 0, 0))))
    If maxCommandId < global_008292C8 Then maxCommandId = global_008292C8
    If maxCommandId < 0 Then maxCommandId = 0
    ReDim global_008292CC(0 To maxCommandId)

    rows = Split(CStr(Proc_5_2_6D4690("SELECT id_command,petlevel_required,command,command_action FROM bots_petcommands", 0, 0)), Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 3 Then
                cacheIndex = CLng(Val(CStr(fields(0))))
                If cacheIndex >= LBound(global_008292CC) And cacheIndex <= UBound(global_008292CC) Then
                    global_008292CC(cacheIndex) = CStr(Val(CStr(fields(0)))) & Chr$(9) & CStr(Val(CStr(fields(1)))) & Chr$(9) & CStr(fields(2)) & Chr$(9) & CStr(fields(3))
                End If
            End If
        End If
    Next rowIndex

BuildFailed:
    Proc_1_7_6C5E10 = Empty
End Function

' Original declaration: Private Sub Proc_1_8_6C6850
Public Function Proc_1_8_6C6850(ParamArray args() As Variant) As Variant
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim cacheKey As String
    Dim cacheValue As String

    On Error GoTo BuildFailed

    rows = Split(CStr(Proc_5_2_6D4690("SELECT variable,value FROM locales WHERE category='2' AND variable LIKE 'roomevent_type_" & Chr$(37) & "'", 0, 0)), Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 1 Then
                cacheKey = Replace(CStr(fields(0)), "roomevent_type_", vbNullString, 1, 1, vbBinaryCompare)
                cacheValue = CStr(fields(1))
                If Len(cacheKey) > 0 Then
                    global_008291AC = global_008291AC & Chr$(0) & CStr(Val(cacheKey)) & Chr$(1) & cacheValue & Chr$(2)
                End If
            End If
        End If
    Next rowIndex

BuildFailed:
    Proc_1_8_6C6850 = Empty
End Function

' Original declaration: Private Sub Proc_1_9_6C6DF0
Public Function Proc_1_9_6C6DF0(ParamArray args() As Variant) As Variant
    Dim settingsRows() As String
    Dim rowIndex As Long
    Dim settingRecord As String
    Dim clientDateFormat As String
    Dim clientTimeFormat As String
    Dim mysqlDateFormat As String
    Dim mysqlTimeFormat As String

    On Error GoTo BuildFailed

    global_00829098 = "0" & CStr(Proc_5_2_6D4690("SELECT id_room,position_x,position_y,id_warp_room,warp_x,warp_y,is_special FROM rooms_warpspaces", Chr$(13), 0)) & Chr$(13)
    global_0082909C = CStr(Proc_5_2_6D4690("SELECT  id_room,is_open FROM  rooms_specialgates", Chr$(13), 0)) & Chr$(13)
    Proc_1_16_6CCA60 0, 0, 0

    global_0082928C = vbNullString
    settingsRows = Split(CStr(Proc_5_2_6D4690("SELECT variable,value FROM settings", 0, 0)), Chr$(13))
    For rowIndex = LBound(settingsRows) To UBound(settingsRows)
        If Len(settingsRows(rowIndex)) > 0 Then
            settingRecord = Replace(CStr(settingsRows(rowIndex)), Chr$(9), "=", 1, -1, vbBinaryCompare)
            global_0082928C = global_0082928C & "[" & settingRecord & "]"
        End If
    Next rowIndex

    clientDateFormat = Replace(Replace(Replace(CStr(Proc_10_0_809570("com.system.format.date", vbNullString, 0)), "d", "dd", 1, -1, vbBinaryCompare), "Y", "yyyy", 1, -1, vbBinaryCompare), "m", "mm", 1, -1, vbBinaryCompare)
    clientTimeFormat = Replace(Replace(Replace(CStr(Proc_10_0_809570("com.system.format.time", vbNullString, 0)), "i", "nn", 1, -1, vbBinaryCompare), "h", "hh", 1, -1, vbBinaryCompare), "s", "ss", 1, -1, vbBinaryCompare)
    mysqlDateFormat = Replace(Replace(CStr(Proc_10_0_809570("com.system.format.date", vbNullString, 0)), "d", Chr$(37) & "d", 1, -1, vbBinaryCompare), "Y", Chr$(37) & "Y", 1, -1, vbBinaryCompare)
    mysqlDateFormat = Replace(mysqlDateFormat, "m", Chr$(37) & "m", 1, -1, vbBinaryCompare)
    mysqlTimeFormat = Replace(Replace(CStr(Proc_10_0_809570("com.system.format.time", vbNullString, 0)), "i", Chr$(37) & "i", 1, -1, vbBinaryCompare), "h", Chr$(37) & "H", 1, -1, vbBinaryCompare)
    mysqlTimeFormat = Replace(mysqlTimeFormat, "s", Chr$(37) & "s", 1, -1, vbBinaryCompare)

    global_0082928C = global_0082928C & "[com.client.format.date=" & clientDateFormat & "]"
    global_0082928C = global_0082928C & "[com.client.format.time=" & clientTimeFormat & "]"
    global_0082928C = global_0082928C & "[com.mysql.format.date=" & mysqlDateFormat & "]"
    global_0082928C = global_0082928C & "[com.mysql.format.time=" & mysqlTimeFormat & "]"

    global_00829080 = CStr(Proc_5_2_6D4690("SELECT id,level,name,NULL,reward,reward_type,require_action,id_additional,id_campaign,amount_activities,waitamount FROM quests ORDER BY id_campaign DESC,level ASC", 0, 0))

BuildFailed:
    Proc_1_9_6C6DF0 = Empty
End Function

' Original declaration: Private Sub Proc_1_10_6C7690
Public Function Proc_1_10_6C7690(ParamArray args() As Variant) As Variant
    Dim rankIndex As Long
    Dim hcLevel As Long
    Dim callForHelpMessages As String
    Dim categoryPayload As String
    Dim moderatorMessages As String
    Dim payload As String

    On Error GoTo BuildFailed

    callForHelpMessages = BuildStaffMessageList(1)
    categoryPayload = BuildStaffCategoryPayload()
    moderatorMessages = BuildStaffMessageList(2)

    ReDim global_008292D8(0 To 20, 0 To 2)
    For rankIndex = 0 To 20
        For hcLevel = 0 To 2
            payload = vbNullString
            payload = payload & AppendPermissionPayload(rankIndex, hcLevel, "fuse_mod", callForHelpMessages & categoryPayload)
            payload = payload & AppendPermissionPayload(rankIndex, hcLevel, "fuse_receive_calls_for_help", callForHelpMessages)
            payload = payload & AppendPermissionPayload(rankIndex, hcLevel, "fuse_chatlog", vbNullString)
            payload = payload & AppendPermissionPayload(rankIndex, hcLevel, "fuse_alert", vbNullString)
            payload = payload & AppendPermissionPayload(rankIndex, hcLevel, "fuse_kick", vbNullString)
            payload = payload & AppendPermissionPayload(rankIndex, hcLevel, "fuse_ban", vbNullString)
            payload = payload & AppendPermissionPayload(rankIndex, hcLevel, "fuse_room_alert", vbNullString)
            payload = payload & AppendPermissionPayload(rankIndex, hcLevel, "fuse_room_kick", vbNullString)
            payload = payload & AppendPermissionPayload(rankIndex, hcLevel, "fuse_edit_localizations", moderatorMessages)
            global_008292D8(rankIndex, hcLevel) = payload
        Next hcLevel
    Next rankIndex

BuildFailed:
    Proc_1_10_6C7690 = Empty
End Function

' Original declaration: Private Sub Proc_1_11_6C8D10
Public Function Proc_1_11_6C8D10(ParamArray args() As Variant) As Variant
    Dim privateCategoryId As Long
    Dim publicCategoryId As Long
    Dim parentCategoryId As Long

    On Error GoTo BuildFailed

    privateCategoryId = CLng(Val(CStr(Proc_10_0_809570("com.client.navigator.categories.default.private.id", 0, 0))))
    publicCategoryId = CLng(Val(CStr(Proc_10_0_809570("com.client.navigator.categories.default.public.id", 0, 0))))

    ReDim global_00829224(0 To 2)
    global_00829224(0) = privateCategoryId
    global_00829224(2) = publicCategoryId

    parentCategoryId = privateCategoryId
    If parentCategoryId = 0 Then parentCategoryId = 1
    global_00829230 = CStr(Proc_5_2_6D4690("SELECT id,name,has_trading,level_minrequired,hclevel_minrequired FROM rooms_categories WHERE id_parent='" & CStr(parentCategoryId) & "' ORDER BY id ASC", 0, 0))

BuildFailed:
    Proc_1_11_6C8D10 = Empty
End Function

' Original declaration: Private Sub Proc_1_12_6C8EF0
Public Function Proc_1_12_6C8EF0(ParamArray args() As Variant) As Variant
    Dim categoryRows() As String
    Dim fields() As String
    Dim rankIndex As Long
    Dim hcLevel As Long
    Dim rowIndex As Long
    Dim categoryCount As Long
    Dim categoryId As Long
    Dim hasTrading As Long
    Dim minRank As Long
    Dim minHcLevel As Long
    Dim categoryPayload As String

    On Error GoTo BuildFailed

    ReDim global_00829244(0 To 20, 0 To 2)
    categoryRows = Split(CStr(global_00829230), Chr$(13))

    For rankIndex = 0 To 20
        For hcLevel = 0 To 2
            categoryPayload = vbNullString
            categoryCount = 0

            For rowIndex = LBound(categoryRows) To UBound(categoryRows)
                If Len(categoryRows(rowIndex)) > 0 Then
                    fields = Split(categoryRows(rowIndex), Chr$(9))
                    If UBound(fields) >= 4 Then
                        categoryId = CLng(Val(CStr(fields(0))))
                        hasTrading = CLng(Val(CStr(fields(2))))
                        minRank = CLng(Val(CStr(fields(3))))
                        minHcLevel = CLng(Val(CStr(fields(4))))

                        If rankIndex >= minRank And hcLevel >= minHcLevel Then
                            categoryPayload = categoryPayload & CStr(Proc_3_0_6D2AF0(categoryId, Empty, vbNullString))
                            categoryPayload = categoryPayload & CStr(fields(1)) & Chr$(2)
                            categoryPayload = categoryPayload & CStr(Proc_3_0_6D2AF0(hasTrading, Empty, vbNullString))
                            categoryCount = categoryCount + 1
                        End If
                    End If
                End If
            Next rowIndex

            global_00829244(rankIndex, hcLevel) = CStr(Proc_3_0_6D2AF0(categoryCount, Empty, vbNullString)) & categoryPayload
        Next hcLevel
    Next rankIndex

BuildFailed:
    Proc_1_12_6C8EF0 = Empty
End Function

' Original declaration: Private Sub Proc_1_13_6C9820
Public Function Proc_1_13_6C9820(ParamArray args() As Variant) As Variant
    Dim rows() As String
    Dim rowIndex As Long
    Dim wrapId As Long
    Dim wrapCount As Long
    Dim accessoryCount As Long
    Dim colorCount As Long
    Dim optionIndex As Long
    Dim wrapPayload As String
    Dim accessoryPayload As String
    Dim colorPayload As String

    On Error GoTo BuildFailed

    global_0082925C = vbCr & CStr(Proc_5_2_6D4690("SELECT id FROM products WHERE sprite LIKE 'present_wrap*" & Chr$(37) & "'", Chr$(13), 0)) & vbCr
    rows = Split(global_0082925C, vbCr)

    For rowIndex = LBound(rows) To UBound(rows)
        wrapId = CLng(Val(CStr(rows(rowIndex))))
        If wrapId <> 0 Then
            wrapCount = wrapCount + 1
            wrapPayload = CStr(Proc_3_0_6D2AF0(wrapId, Empty, wrapPayload))
        End If
    Next rowIndex

    accessoryCount = CLng(Val(CStr(Proc_10_0_809570("com.client.catalog.gifts.wrap.count.accessories", wrapCount, 0))))
    For optionIndex = 1 To accessoryCount
        accessoryPayload = CStr(Proc_3_0_6D2AF0(optionIndex, Empty, accessoryPayload))
    Next optionIndex

    colorCount = CLng(Val(CStr(Proc_10_0_809570("com.client.catalog.gifts.wrap.count.colors", 0, 0))))
    For optionIndex = 1 To colorCount
        colorPayload = CStr(Proc_3_0_6D2AF0(optionIndex, Empty, colorPayload))
    Next optionIndex

    global_00829260 = CStr(Proc_3_0_6D2AF0(accessoryCount, Empty, vbNullString)) & accessoryPayload
    global_00829260 = CStr(Proc_3_0_6D2AF0(wrapCount, Empty, global_00829260)) & wrapPayload
    global_00829260 = CStr(Proc_3_0_6D2AF0(colorCount, Empty, global_00829260)) & colorPayload

BuildFailed:
    Proc_1_13_6C9820 = Empty
End Function

' Original declaration: Private  Proc_1_14_6C9DD0(arg_C, arg_10, arg_14, arg_18) '6C9DD0
Public Function Proc_1_14_6C9DD0(ParamArray args() As Variant) As Variant
    Dim pageId As Long
    Dim parentId As Long
    Dim caption As String
    Dim visibleState As Long
    Dim iconId As Long
    Dim childCount As Long
    Dim payload As String

    On Error GoTo BuildFailed

    If UBound(args) >= 0 Then pageId = CLng(Val(CStr(args(0))))
    If UBound(args) >= 1 Then parentId = CLng(Val(CStr(args(1))))
    If UBound(args) >= 2 Then caption = CStr(args(2))
    If UBound(args) >= 3 Then visibleState = CLng(Val(CStr(args(3))))
    If UBound(args) >= 4 Then iconId = CLng(Val(CStr(args(4))))
    If UBound(args) >= 5 Then childCount = CLng(Val(CStr(args(5))))

    payload = "0"
    payload = payload & CStr(Proc_3_0_6D2AF0(pageId, Empty, vbNullString))
    payload = payload & CStr(Proc_3_0_6D2AF0(parentId, Empty, vbNullString))
    payload = payload & CStr(Proc_3_0_6D2AF0(iconId, Empty, vbNullString))
    payload = payload & CStr(Proc_3_0_6D2AF0(visibleState, Empty, vbNullString))

    Proc_1_14_6C9DD0 = payload & caption & Chr$(2) & CStr(Proc_3_0_6D2AF0(childCount, Empty, vbNullString))
    Exit Function

BuildFailed:
    Proc_1_14_6C9DD0 = vbNullString
End Function

' Original declaration: Private Sub Proc_1_15_6CA000
Public Function Proc_1_15_6CA000(ParamArray args() As Variant) As Variant
    Dim maxPageId As Long
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim pageId As Long
    Dim pageQuery As String

    On Error GoTo BuildFailed

    maxPageId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT MAX(id) FROM catalog_pages", 0, 0))))
    ReDim global_00829308(0 To maxPageId)

    pageQuery = "SELECT id,name,level_minrequired,hclevel_minrequired,is_clickable,ctlg_template,"
    pageQuery = pageQuery & "ctlg_header_img,ctlg_special_img,ctlg_special_template,ctlg_txt1,ctlg_txt2,"
    pageQuery = pageQuery & "ctlg_txt3,ctlg_txt4,ctlg_txt5,ctlg_txt6,ctlg_txt7,ctlg_txt8,ctlg_txt9,"
    pageQuery = pageQuery & "ctlg_txt10,ctlg_txt11,ctlg_link,is_develop FROM catalog_pages ORDER BY id_order ASC"

    rows = Split(CStr(Proc_5_2_6D4690(pageQuery, 0, 0)), Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 21 Then
                pageId = CLng(Val(CStr(fields(0))))
                If pageId >= LBound(global_00829308) And pageId <= UBound(global_00829308) Then
                    global_00829308(pageId) = BuildCatalogPagePayload(fields)
                End If
            End If
        End If
    Next rowIndex

    Proc_1_15_6CA000 = Empty
    Exit Function

BuildFailed:
    Proc_1_15_6CA000 = Empty
End Function

' Original declaration: Private Sub Proc_1_16_6CCA60
Public Function Proc_1_16_6CCA60(ParamArray args() As Variant) As Variant
    Dim rankIndex As Long
    Dim hcLevel As Long
    Dim privilegeRows As String

    On Error GoTo BuildFailed

    ReDim global_008292A8(0 To 20, 0 To 2)

    For rankIndex = 0 To 20
        For hcLevel = 0 To 2
            privilegeRows = CStr(Proc_5_2_6D4690("SELECT privilege FROM level_privileges WHERE min_level <= '" & CStr(rankIndex) & "' AND min_level_hc <= '" & CStr(hcLevel) & "'", 0, 0))
            If Len(privilegeRows) > 0 Then
                global_008292A8(rankIndex, hcLevel) = Chr$(2) & Replace(privilegeRows, Chr$(13), Chr$(2), 1, -1, vbBinaryCompare) & Chr$(2)
            Else
                global_008292A8(rankIndex, hcLevel) = Chr$(2)
            End If
        Next hcLevel
    Next rankIndex

BuildFailed:
    Proc_1_16_6CCA60 = Empty
End Function

' Original declaration: Private Sub Proc_1_17_6CCDC0
Public Function Proc_1_17_6CCDC0(ParamArray args() As Variant) As Variant
    Dim rankIndex As Long
    Dim hcLevel As Long

    On Error GoTo BuildFailed

    ReDim global_008292F4(0 To 20, 0 To 2)
    For rankIndex = 0 To 20
        For hcLevel = 0 To 2
            global_008292F4(rankIndex, hcLevel) = BuildCatalogPageTreePayload(rankIndex, hcLevel)
        Next hcLevel
    Next rankIndex

    Proc_1_17_6CCDC0 = Empty
    Exit Function

BuildFailed:
    Proc_1_17_6CCDC0 = Empty
End Function

' Original declaration: Private Sub Proc_1_18_6CE9C0
Public Function Proc_1_18_6CE9C0(ParamArray args() As Variant) As Variant
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim giftCount As Long
    Dim catalogProductId As Long
    Dim productId As Long
    Dim isVip As Long
    Dim requiredDays As Long
    Dim giftClass As String
    Dim giftName As String
    Dim giftDescription As String
    Dim giftPayload As String

    On Error GoTo BuildFailed

    global_00829178 = vbNullString
    global_0082917C = vbNullString

    rows = Split(CStr(Proc_5_2_6D4690("SELECT id_product,is_vip,required_days FROM club_gifts ORDER by id ASC", 0, 0)), Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 2 Then
                catalogProductId = CLng(Val(CStr(fields(0))))
                productId = CLng(Val(CStr(Proc_9_2_8075F0(catalogProductId, 2, 0))))
                If productId = 0 Then productId = catalogProductId
                isVip = CLng(Val(CStr(fields(1))))
                requiredDays = CLng(Val(CStr(fields(2))))
                giftClass = "s"
                If CLng(Val(CStr(Proc_9_0_806F70(productId, 1, 0)))) = 9 Then giftClass = "i"
                giftName = CStr(Proc_8_12_806C30(productId, 14, 0))
                giftDescription = CStr(Proc_8_12_806C30(productId, 15, 0))

                giftPayload = CStr(Proc_3_0_6D2AF0(catalogProductId, Empty, vbNullString))
                giftPayload = giftPayload & CStr(Proc_3_0_6D2AF0(productId, Empty, vbNullString))
                giftPayload = giftPayload & giftName & Chr$(2) & giftDescription & Chr$(2)
                giftPayload = giftPayload & "IHHI" & giftClass & Chr$(2)
                giftPayload = giftPayload & CStr(Proc_3_0_6D2AF0(isVip, Empty, vbNullString))
                giftPayload = giftPayload & CStr(Proc_3_0_6D2AF0(requiredDays, Empty, vbNullString))

                global_00829178 = global_00829178 & giftPayload
                global_0082917C = global_0082917C & "[" & CStr(catalogProductId) & Chr$(0) & CStr(productId) & Chr$(1) & CStr(requiredDays) & "]"
                giftCount = giftCount + 1
            End If
        End If
    Next rowIndex

    global_00829178 = CStr(Proc_3_0_6D2AF0(giftCount, Empty, vbNullString)) & global_00829178

BuildFailed:
    Proc_1_18_6CE9C0 = Empty
End Function

' Original declaration: Private Sub Proc_1_19_6CF190
Public Function Proc_1_19_6CF190(ParamArray args() As Variant) As Variant
    Dim importanceLevel As Long
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim groupPayload As String
    Dim groupCount As Long

    On Error GoTo BuildFailed

    global_00829204 = vbNullString
    For importanceLevel = 1 To 2
        groupPayload = vbNullString
        groupCount = 0
        rows = Split(CStr(Proc_5_2_6D4690("SELECT id,name FROM faq WHERE is_important='" & CStr(importanceLevel) & "' ORDER BY id DESC LIMIT 1", 0, 0)), Chr$(13))

        For rowIndex = LBound(rows) To UBound(rows)
            If Len(rows(rowIndex)) > 0 Then
                fields = Split(rows(rowIndex), Chr$(9))
                If UBound(fields) >= 1 Then
                    groupPayload = CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(fields(0)))), Empty, groupPayload)) & CStr(fields(1)) & Chr$(2)
                    groupCount = groupCount + 1
                End If
            End If
        Next rowIndex

        global_00829204 = global_00829204 & CStr(Proc_3_0_6D2AF0(groupCount, Empty, vbNullString)) & groupPayload
    Next importanceLevel

    global_00829204 = CStr(Proc_3_0_6D2AF0(2, Empty, vbNullString)) & global_00829204

BuildFailed:
    Proc_1_19_6CF190 = Empty
End Function

' Original declaration: Private Sub Proc_1_20_6CF830
Public Function Proc_1_20_6CF830(ParamArray args() As Variant) As Variant
    Dim maxCategoryId As Long
    Dim categoryRows() As String
    Dim categoryFields() As String
    Dim faqRows() As String
    Dim faqFields() As String
    Dim categoryIndex As Long
    Dim faqIndex As Long
    Dim categoryId As Long
    Dim categoryCount As Long
    Dim faqCount As Long
    Dim categoryPayload As String
    Dim faqPayload As String

    On Error GoTo BuildFailed

    maxCategoryId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT MAX(id) FROM faq_categories", 0, 0))))
    If maxCategoryId < 0 Then maxCategoryId = 0
    ReDim global_0082920C(0 To maxCategoryId)

    global_00829208 = vbNullString
    categoryRows = Split(CStr(Proc_5_2_6D4690("SELECT id,name FROM faq_categories", 0, 0)), Chr$(13))
    For categoryIndex = LBound(categoryRows) To UBound(categoryRows)
        If Len(categoryRows(categoryIndex)) > 0 Then
            categoryFields = Split(categoryRows(categoryIndex), Chr$(9))
            If UBound(categoryFields) >= 1 Then
                categoryId = CLng(Val(CStr(categoryFields(0))))
                If categoryId >= LBound(global_0082920C) And categoryId <= UBound(global_0082920C) Then
                    faqPayload = vbNullString
                    faqCount = 0
                    faqRows = Split(CStr(Proc_5_2_6D4690("SELECT id,name FROM faq WHERE id_category='" & CStr(categoryId) & "'", 0, 0)), Chr$(13))
                    For faqIndex = LBound(faqRows) To UBound(faqRows)
                        If Len(faqRows(faqIndex)) > 0 Then
                            faqFields = Split(faqRows(faqIndex), Chr$(9))
                            If UBound(faqFields) >= 1 Then
                                faqPayload = CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(faqFields(0)))), Empty, faqPayload)) & CStr(faqFields(1)) & Chr$(2)
                                faqCount = faqCount + 1
                            End If
                        End If
                    Next faqIndex

                    global_0082920C(categoryId) = CStr(Proc_3_0_6D2AF0(faqCount, Empty, vbNullString)) & faqPayload
                    categoryPayload = categoryPayload & CStr(Proc_3_0_6D2AF0(categoryId, Empty, vbNullString)) & CStr(categoryFields(1)) & Chr$(2)
                    categoryCount = categoryCount + 1
                End If
            End If
        End If
    Next categoryIndex

    global_00829208 = CStr(Proc_3_0_6D2AF0(categoryCount, Empty, vbNullString)) & categoryPayload

BuildFailed:
    Proc_1_20_6CF830 = Empty
End Function

' Original declaration: Private Sub Proc_1_21_6D08C0
Public Function Proc_1_21_6D08C0(ParamArray args() As Variant) As Variant
    Dim maxFaqId As Long
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim faqId As Long
    Dim descriptionText As String

    On Error GoTo BuildFailed

    maxFaqId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT MAX(id) FROM faq", 0, 0))))
    If maxFaqId < 0 Then maxFaqId = 0
    ReDim global_00829210(0 To maxFaqId)

    rows = Split(CStr(Proc_5_2_6D4690("SELECT id,description FROM faq", 0, 0)), Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 1 Then
                faqId = CLng(Val(CStr(fields(0))))
                If faqId >= LBound(global_00829210) And faqId <= UBound(global_00829210) Then
                    descriptionText = Replace(CStr(fields(1)), Chr$(10), Chr$(13), 1, -1, vbBinaryCompare)
                    global_00829210(faqId) = CStr(Proc_3_0_6D2AF0(faqId, Empty, vbNullString)) & descriptionText & Chr$(2)
                End If
            End If
        End If
    Next rowIndex

BuildFailed:
    Proc_1_21_6D08C0 = Empty
End Function

' Original declaration: Private Sub Proc_1_22_6D0F00
Public Function Proc_1_22_6D0F00(ParamArray args() As Variant) As Variant
    Dim maxId As Long
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim visitRoomId As Long
    Dim assetPath As String

    On Error GoTo BuildFailed

    maxId = CLng(Val(CStr(Proc_5_2_6D4690("SELECT MAX(id) FROM advertisement_visitrooms", 0, 0))))
    If maxId < 0 Then maxId = 0
    ReDim global_008291D4(0 To maxId)
    global_008291D8 = 0

    assetPath = CStr(Proc_10_0_809570("com.server.socket.game.advertisement.visitrooms.path", vbNullString, 0))
    rows = Split(CStr(Proc_5_2_6D4690("SELECT id,address FROM advertisement_visitrooms", 0, 0)), Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 1 Then
                visitRoomId = CLng(Val(CStr(fields(0))))
                If visitRoomId >= LBound(global_008291D4) And visitRoomId <= UBound(global_008291D4) Then
                    global_008291D8 = global_008291D8 + 1
                    global_008291D4(visitRoomId) = assetPath & CStr(visitRoomId) & Chr$(2) & CStr(fields(1)) & Chr$(2)
                End If
            End If
        End If
    Next rowIndex

BuildFailed:
    Proc_1_22_6D0F00 = Empty
End Function

' Original declaration: Private  Proc_1_23_6D1480(arg_C) '6D1480
Public Function Proc_1_23_6D1480(ParamArray args() As Variant) As Variant
    Dim messageText As String
    Dim logChannel As String

    On Error GoTo LogFailed
    If UBound(args) >= 0 Then messageText = CStr(args(0))
    If UBound(args) >= 1 Then logChannel = CStr(args(1))
    Proc_2_0_6D1510 messageText, logChannel, CStr(65280)

LogFailed:
    Proc_1_23_6D1480 = Empty
End Function

Private Sub CacheRowsById(ByRef targetCache As Variant, ByVal rowText As String)
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim cacheIndex As Long

    On Error GoTo CacheFailed
    rows = Split(rowText, Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 0 Then
                cacheIndex = CLng(Val(CStr(fields(0))))
                If cacheIndex >= LBound(targetCache) And cacheIndex <= UBound(targetCache) Then
                    targetCache(cacheIndex) = rows(rowIndex)
                End If
            End If
        End If
    Next rowIndex

CacheFailed:
End Sub

Private Sub BuildCampaignReplacementCache()
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim payload As String
    Dim replacementCount As Long

    On Error GoTo CacheFailed
    rows = Split(CStr(Proc_5_2_6D4690("SELECT sprite_default,sprite_replacement FROM products_campaign WHERE is_active='1'", 0, 0)), Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 1 Then
                payload = payload & CStr(fields(0)) & Chr$(2) & CStr(fields(1)) & Chr$(2)
                replacementCount = replacementCount + 1
            End If
        End If
    Next rowIndex

    global_00829094 = CStr(Proc_3_0_6D2AF0(replacementCount, Empty, vbNullString)) & payload

CacheFailed:
End Sub

Private Sub BuildAchievementSettingsCache()
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim achievementIndex As Long

    On Error GoTo CacheFailed
    global_008291E4 = vbNullString
    ReDim global_008291E8(0 To 100, 0 To 6)

    rows = Split(CStr(Proc_5_2_6D4690("SELECT id_quest,id_badge,progress,reward_increase,level_total,score_increase,type_reward FROM settings_achievements WHERE is_enabled='1' LIMIT 100", 0, 0)), Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If achievementIndex > 100 Then Exit For
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 6 Then
                global_008291E4 = global_008291E4 & CStr(Val(CStr(fields(0)))) & Chr$(2)
                global_008291E8(achievementIndex, 0) = CLng(Val(CStr(fields(0))))
                global_008291E8(achievementIndex, 1) = CStr(fields(1))
                global_008291E8(achievementIndex, 2) = CLng(Val(CStr(fields(2))))
                global_008291E8(achievementIndex, 3) = CLng(Val(CStr(fields(3))))
                global_008291E8(achievementIndex, 4) = CLng(Val(CStr(fields(4))))
                global_008291E8(achievementIndex, 5) = CLng(Val(CStr(fields(5))))
                global_008291E8(achievementIndex, 6) = CInt(Val(CStr(fields(6))))
                achievementIndex = achievementIndex + 1
            End If
        End If
    Next rowIndex

CacheFailed:
End Sub

Private Sub BuildChatSettingsCache()
    On Error GoTo CacheFailed
    global_00829294 = CStr(Proc_5_2_6D4690("SELECT smiley,gesture FROM settings_gesture LIMIT 100", 0, 0))
    global_00829290 = CStr(Proc_5_2_6D4690("SELECT word FROM settings_filter LIMIT 100", 0, 0))

CacheFailed:
End Sub

Private Sub BuildMessengerFriendLimitCache()
    On Error GoTo CacheFailed
    ReDim global_0082927C(0 To 4)
    global_0082927C(0) = CInt(Val(CStr(Proc_10_0_809570("com.client.messenger.maxfriends.hclevel0", 0, 0))))
    global_0082927C(2) = CInt(Val(CStr(Proc_10_0_809570("com.client.messenger.maxfriends.hclevel1", 0, 0))))
    global_0082927C(4) = CInt(Val(CStr(Proc_10_0_809570("com.client.messenger.maxfriends.hclevel2", 0, 0))))

CacheFailed:
End Sub

Private Function BuildStaffMessageList(ByVal messageType As Long) As String
    Dim rows() As String
    Dim rowIndex As Long
    Dim payload As String

    On Error GoTo BuildFailed
    rows = Split(CStr(Proc_5_2_6D4690("SELECT message FROM staff_predefined_messages WHERE id_type='" & CStr(messageType) & "'", 0, 0)), Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            payload = payload & CStr(rows(rowIndex)) & Chr$(2)
        End If
    Next rowIndex

BuildFailed:
    BuildStaffMessageList = payload
End Function

Private Function BuildStaffCategoryPayload() As String
    Dim rootRows() As String
    Dim rootFields() As String
    Dim childRows() As String
    Dim childFields() As String
    Dim rootIndex As Long
    Dim childIndex As Long
    Dim rootId As Long
    Dim childCount As Long
    Dim childPayload As String
    Dim payload As String

    On Error GoTo BuildFailed
    rootRows = Split(CStr(Proc_5_2_6D4690("SELECT id,description FROM staff_predefined_categories WHERE id_parent='0'", 0, 0)), Chr$(13))
    For rootIndex = LBound(rootRows) To UBound(rootRows)
        If Len(rootRows(rootIndex)) > 0 Then
            rootFields = Split(rootRows(rootIndex), Chr$(9))
            If UBound(rootFields) >= 1 Then
                rootId = CLng(Val(CStr(rootFields(0))))
                childCount = 0
                childPayload = vbNullString
                childRows = Split(CStr(Proc_5_2_6D4690("SELECT id,description FROM staff_predefined_categories WHERE id_parent='" & CStr(rootId) & "'", 0, 0)), Chr$(13))
                For childIndex = LBound(childRows) To UBound(childRows)
                    If Len(childRows(childIndex)) > 0 Then
                        childFields = Split(childRows(childIndex), Chr$(9))
                        If UBound(childFields) >= 1 Then
                            childCount = childCount + 1
                            childPayload = childPayload & CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(childFields(0)))), Empty, vbNullString)) & CStr(childFields(1)) & Chr$(2)
                        End If
                    End If
                Next childIndex

                payload = payload & CStr(Proc_3_0_6D2AF0(rootId, Empty, vbNullString)) & CStr(rootFields(1)) & Chr$(2)
                payload = payload & CStr(Proc_3_0_6D2AF0(childCount, Empty, vbNullString)) & childPayload
            End If
        End If
    Next rootIndex

BuildFailed:
    BuildStaffCategoryPayload = payload
End Function

Private Function BuildRecommendedRoomsQuery(ByVal treeId As Long) As String
    Dim queryText As String
    Dim treeText As String
    Dim separator As String

    treeText = CStr(treeId)
    separator = " UNION ALL "

    queryText = "SELECT rooms_recommented.id_type,rooms_recommented.id_style,rooms_recommented.icon,"
    queryText = queryText & "rooms_recommented.caption,rooms_recommented.caption_2,rooms_recommented.caption_3,"
    queryText = queryText & "NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,"
    queryText = queryText & "rooms_recommented.id_tree,rooms_recommented.id FROM rooms_recommented WHERE id_tree='"
    queryText = queryText & treeText & "' AND rooms_recommented.id_type='1' GROUP BY rooms_recommented.id"

    queryText = queryText & separator & "SELECT rooms_recommented.id_type,rooms_recommented.id_style,rooms_recommented.icon,"
    queryText = queryText & "rooms_recommented.caption,rooms_recommented.caption_2,rooms_recommented.caption_3,NULL,"
    queryText = queryText & "rooms.id,rooms.name,users.name,rooms.status_door,rooms.visitors_now,rooms.visitors_max,"
    queryText = queryText & "rooms.description,rooms_categories.has_trading,NULL,rooms.rate,rooms.id_category,rooms.icon,"
    queryText = queryText & "rooms.tag_1,rooms.tag_2,rooms.allow_otherspets,NULL,NULL,NULL,"
    queryText = queryText & "rooms_recommented.id_tree,rooms_recommented.id FROM users,rooms,rooms_categories,rooms_recommented "
    queryText = queryText & "WHERE id_tree='" & treeText & "' AND rooms_recommented.id_type='2' "
    queryText = queryText & "AND rooms_recommented.id_room IS NOT NULL AND rooms.id=rooms_recommented.id_room "
    queryText = queryText & "AND users.id=rooms.id_owner AND rooms_categories.id=rooms.id_category GROUP BY rooms_recommented.id"

    queryText = queryText & separator & "SELECT rooms_recommented.id_type,rooms_recommented.id_style,rooms_recommented.icon,"
    queryText = queryText & "rooms_recommented.caption,rooms_recommented.caption_2,rooms_recommented.caption_3,NULL,"
    queryText = queryText & "rooms.id,rooms.name,NULL,rooms.status_door,rooms.visitors_now,rooms.visitors_max,"
    queryText = queryText & "rooms.description,rooms_categories.has_trading,NULL,rooms.rate,rooms.id_category,rooms.icon,"
    queryText = queryText & "rooms.tag_1,rooms.tag_2,rooms.allow_otherspets,models.name,models.required_files,models.visitors_max,"
    queryText = queryText & "rooms_recommented.id_tree,rooms_recommented.id FROM models,rooms,rooms_categories,rooms_recommented "
    queryText = queryText & "WHERE id_tree='" & treeText & "' AND rooms_recommented.id_type='3' "
    queryText = queryText & "AND rooms_recommented.id_room IS NOT NULL AND rooms.id=rooms_recommented.id_room "
    queryText = queryText & "AND models.id=rooms.id_model AND rooms_categories.id=rooms.id_category GROUP BY rooms_recommented.id"

    queryText = queryText & separator & "SELECT rooms_recommented.id_type,rooms_recommented.id_style,rooms_recommented.icon,"
    queryText = queryText & "rooms_recommented.caption,rooms_recommented.caption_2,rooms_recommented.caption_3,"
    queryText = queryText & "NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,"
    queryText = queryText & "rooms_recommented.id_tree,rooms_recommented.id FROM rooms_recommented WHERE id_tree='"
    queryText = queryText & treeText & "' AND rooms_recommented.id_type='4' GROUP BY rooms_recommented.id ORDER BY 27 ASC LIMIT 255"

    BuildRecommendedRoomsQuery = queryText
End Function

Private Function BuildRecommendedRoomsPayload(ByVal roomRows As String) As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim fieldIndex As Long
    Dim roomCount As Long
    Dim rowPayload As String
    Dim payload As String

    On Error GoTo BuildFailed

    rows = Split(roomRows, Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 26 Then
                roomCount = roomCount + 1
                rowPayload = CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(fields(0)))), Empty, vbNullString))
                rowPayload = rowPayload & CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(fields(1)))), Empty, vbNullString))
                rowPayload = rowPayload & CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(fields(2)))), Empty, vbNullString))
                For fieldIndex = 3 To 24
                    rowPayload = rowPayload & CStr(fields(fieldIndex)) & Chr$(2)
                Next fieldIndex
                rowPayload = rowPayload & CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(fields(25)))), Empty, vbNullString))
                rowPayload = rowPayload & CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(fields(26)))), Empty, vbNullString))
                payload = payload & rowPayload
            End If
        End If
    Next rowIndex

BuildFailed:
    BuildRecommendedRoomsPayload = CStr(Proc_3_0_6D2AF0(roomCount, Empty, vbNullString)) & payload
End Function

Private Function BuildCatalogPageTreePayload(ByVal rankIndex As Long, ByVal hcLevel As Long) As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim rootCount As Long
    Dim payload As String
    Dim pageId As Long
    Dim childCount As Long

    On Error GoTo BuildFailed

    rows = Split(CStr(Proc_5_2_6D4690(BuildCatalogPageTreeQuery(0, rankIndex, hcLevel), 0, 0)), Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 5 Then
                If CatalogPageVisible(fields, rankIndex, hcLevel) Then
                    pageId = CLng(Val(CStr(fields(0))))
                    childCount = CLng(Val(CStr(Proc_5_2_6D4690(BuildCatalogPageChildCountQuery(pageId, rankIndex, hcLevel), 0, 0))))
                    payload = payload & BuildCatalogPageTreeEntry(fields, childCount)
                    payload = payload & BuildCatalogPageChildPayload(pageId, rankIndex, hcLevel)
                    rootCount = rootCount + 1
                End If
            End If
        End If
    Next rowIndex

BuildFailed:
    BuildCatalogPageTreePayload = CStr(Proc_3_0_6D2AF0(rootCount, Empty, vbNullString)) & payload
End Function

Private Function BuildCatalogPagePayload(ByRef fields() As String) As String
    Dim pageId As Long
    Dim textIndex As Long
    Dim textCount As Long
    Dim textPayload As String
    Dim linkPayload As String
    Dim payload As String

    On Error GoTo BuildFailed

    pageId = CLng(Val(CStr(fields(0))))

    payload = CStr(fields(1)) & Chr$(2)
    payload = payload & CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(fields(4)))), Empty, vbNullString))
    payload = payload & CStr(fields(5)) & Chr$(2)
    payload = payload & CStr(fields(6)) & Chr$(2)
    payload = payload & CStr(fields(7)) & Chr$(2)
    payload = payload & CStr(fields(8)) & Chr$(2)

    For textIndex = 9 To 19
        If CatalogTextFieldPresent(CStr(fields(textIndex))) Then
            textCount = textCount + 1
            textPayload = textPayload & CStr(fields(textIndex)) & Chr$(2)
        End If
    Next textIndex
    payload = payload & CStr(Proc_3_0_6D2AF0(textCount, Empty, vbNullString)) & textPayload

    If CatalogTextFieldPresent(CStr(fields(20))) Then
        linkPayload = CStr(fields(20)) & Chr$(2)
        payload = payload & CStr(Proc_3_0_6D2AF0(1, Empty, vbNullString)) & linkPayload
    Else
        payload = payload & CStr(Proc_3_0_6D2AF0(0, Empty, vbNullString))
    End If

    BuildCatalogPagePayload = payload & BuildCatalogProductPayload(pageId)
    Exit Function

BuildFailed:
    BuildCatalogPagePayload = vbNullString
End Function

Private Function BuildCatalogProductPayload(ByVal pageId As Long) As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim productCount As Long
    Dim productPayload As String

    On Error GoTo BuildFailed

    rows = Split(CStr(Proc_5_2_6D4690(BuildCatalogProductQuery(pageId), 0, 0)), Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 9 Then
                productPayload = productPayload & BuildCatalogProductEntry(fields)
                productCount = productCount + 1
            End If
        End If
    Next rowIndex

BuildFailed:
    BuildCatalogProductPayload = CStr(Proc_3_0_6D2AF0(productCount, Empty, vbNullString)) & productPayload
End Function

Private Function BuildCatalogProductEntry(ByRef fields() As String) As String
    Dim catalogProductId As Long
    Dim productId As Long
    Dim productType As Long
    Dim productClass As String
    Dim amountValue As Long
    Dim payload As String

    On Error GoTo BuildFailed

    catalogProductId = CLng(Val(CStr(fields(0))))
    productId = CLng(Val(CStr(fields(1))))
    productType = CLng(Val(CStr(Proc_9_0_806F70(productId, 1, 0))))
    productClass = CatalogProductClass(productType)
    amountValue = CLng(Val(CStr(fields(6))))
    If amountValue <= 0 Then amountValue = 1

    payload = CStr(Proc_3_0_6D2AF0(catalogProductId, Empty, vbNullString))
    payload = payload & CStr(fields(4)) & Chr$(2)
    payload = payload & CStr(Proc_3_0_6D2AF0(productId, Empty, vbNullString))
    payload = payload & productClass & Chr$(2)
    payload = payload & CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(fields(2)))), Empty, vbNullString))
    payload = payload & CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(fields(3)))), Empty, vbNullString))
    payload = payload & CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(fields(5)))), Empty, vbNullString))
    payload = payload & CStr(Proc_3_0_6D2AF0(amountValue, Empty, vbNullString))
    payload = payload & CStr(fields(7)) & Chr$(2)
    payload = payload & CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(fields(8)))), Empty, vbNullString))
    payload = payload & CStr(Proc_3_0_6D2AF0(CLng(Val(CStr(fields(9)))), Empty, vbNullString))

    BuildCatalogProductEntry = payload
    Exit Function

BuildFailed:
    BuildCatalogProductEntry = vbNullString
End Function

Private Function BuildCatalogProductQuery(ByVal pageId As Long) As String
    Dim queryText As String

    queryText = "SELECT id,id_product,price_credits,price_activitypoints,sprite,type_activitypoints,"
    queryText = queryText & "amount,type_secondary,replace_defaultsign,min_hc_level_required "
    queryText = queryText & "FROM catalog_products WHERE ctlg_pageid='" & CStr(pageId) & "' "
    queryText = queryText & "ORDER BY id_order,sprite ASC"
    BuildCatalogProductQuery = queryText
End Function

Private Function CatalogTextFieldPresent(ByVal fieldValue As String) As Boolean
    CatalogTextFieldPresent = (Len(fieldValue) > 0 And StrComp(fieldValue, "NULL", vbTextCompare) <> 0)
End Function

Private Function CatalogProductClass(ByVal productType As Long) As String
    Select Case productType
        Case 9
            CatalogProductClass = "i"
        Case 0, 1
            CatalogProductClass = "s"
        Case Else
            CatalogProductClass = "s"
    End Select
End Function

Private Function BuildCatalogPageChildPayload(ByVal parentId As Long, ByVal rankIndex As Long, ByVal hcLevel As Long) As String
    Dim rows() As String
    Dim fields() As String
    Dim rowIndex As Long
    Dim payload As String

    On Error GoTo BuildFailed

    rows = Split(CStr(Proc_5_2_6D4690(BuildCatalogPageTreeQuery(parentId, rankIndex, hcLevel), 0, 0)), Chr$(13))
    For rowIndex = LBound(rows) To UBound(rows)
        If Len(rows(rowIndex)) > 0 Then
            fields = Split(rows(rowIndex), Chr$(9))
            If UBound(fields) >= 5 Then
                If CatalogPageVisible(fields, rankIndex, hcLevel) Then
                    payload = payload & BuildCatalogPageTreeEntry(fields, 0)
                End If
            End If
        End If
    Next rowIndex

BuildFailed:
    BuildCatalogPageChildPayload = payload
End Function

Private Function BuildCatalogPageTreeEntry(ByRef fields() As String, ByVal childCount As Long) As String
    Dim pageId As Long
    Dim colorId As Long
    Dim iconId As Long
    Dim pageName As String
    Dim visibleState As Long

    On Error GoTo BuildFailed

    pageId = CLng(Val(CStr(fields(0))))
    pageName = CStr(fields(1))
    colorId = CLng(Val(CStr(fields(2))))
    iconId = CLng(Val(CStr(fields(3))))
    visibleState = CLng(Val(CStr(fields(5))))

    BuildCatalogPageTreeEntry = CStr(Proc_1_14_6C9DD0(pageId, colorId, pageName, visibleState, iconId, childCount))
    Exit Function

BuildFailed:
    BuildCatalogPageTreeEntry = vbNullString
End Function

Private Function BuildCatalogPageTreeQuery(ByVal parentId As Long, ByVal rankIndex As Long, ByVal hcLevel As Long) As String
    Dim queryText As String

    queryText = "SELECT id,name,ctlg_color,ctlg_icon,is_develop,is_visible FROM catalog_pages "
    queryText = queryText & "WHERE id_parent='" & CStr(parentId) & "' "
    queryText = queryText & "AND level_minrequired <= '" & CStr(rankIndex) & "' "
    queryText = queryText & "AND hclevel_minrequired <= '" & CStr(hcLevel) & "' "
    queryText = queryText & "ORDER BY id_order ASC"
    BuildCatalogPageTreeQuery = queryText
End Function

Private Function BuildCatalogPageChildCountQuery(ByVal parentId As Long, ByVal rankIndex As Long, ByVal hcLevel As Long) As String
    Dim queryText As String

    queryText = "SELECT COUNT(id) FROM catalog_pages WHERE id_parent='" & CStr(parentId) & "' "
    queryText = queryText & "AND level_minrequired <= '" & CStr(rankIndex) & "' "
    queryText = queryText & "AND hclevel_minrequired <= '" & CStr(hcLevel) & "'"
    BuildCatalogPageChildCountQuery = queryText
End Function

Private Function CatalogPageVisible(ByRef fields() As String, ByVal rankIndex As Long, ByVal hcLevel As Long) As Boolean
    On Error GoTo VisibilityFailed
    CatalogPageVisible = (CLng(Val(CStr(fields(5)))) <> 0)
    If CLng(Val(CStr(fields(4)))) <> 0 Then
        CatalogPageVisible = CBool(Proc_10_1_809790(rankIndex, vbNullString, "fuse_developer", hcLevel))
    End If
    Exit Function

VisibilityFailed:
    CatalogPageVisible = False
End Function

Private Function AppendPermissionPayload(ByVal rankIndex As Long, ByVal hcLevel As Long, ByVal permissionName As String, ByVal payload As String) As String
    On Error GoTo BuildFailed
    If CBool(Proc_10_1_809790(rankIndex, vbNullString, permissionName, hcLevel)) Then
        AppendPermissionPayload = permissionName & Chr$(2) & payload
    Else
        AppendPermissionPayload = vbNullString
    End If
    Exit Function

BuildFailed:
    AppendPermissionPayload = vbNullString
End Function
