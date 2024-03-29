local m_myMainForm = nil
local m_template = nil
local m_runeTxtWidget = nil
local m_gsTxtWidget = nil
local m_fairyTxtWidget = nil

function OnTargetChaged(params)
	local targetID = avatar.GetTarget()
	if not targetID or not unit.IsPlayer(targetID) then
		hide(mainForm)
	end
end

function ToStringConv(aText)
	if not aText then return nil end
	if common.IsWString(aText) then
		aText = userMods.FromWString(aText)
	end
	return tostring(aText)
end

function CreateValuedText(aText1, aText2, aText3, aStyle1, aStyle2, aStyle3)
	local formatStr = "<body fontname='AllodsWest' alignx = 'center' fontsize='14'><rs class='style1'>"..(ToStringConv(aText1) or "").."</rs><rs class='style2'>"..(ToStringConv(aText2) or "").."</rs><rs class='style3'>"..(ToStringConv(aText3) or "").."</rs></body>"
	local valuedText=common.CreateValuedText()
	valuedText:SetFormat(toWString(formatStr))
	
	valuedText:SetClassVal( "style1", aStyle1 or "" )
	valuedText:SetClassVal( "style2", aStyle2 or "" )
	valuedText:SetClassVal( "style3", aStyle3 or "" )
	
	return valuedText
end

function RuneToTxt(aRuneVal)
	if aRuneVal == nil then 
		aRuneVal = 0
	end
	local num1, num2 = math.modf(aRuneVal)
	local runeTxt = tostring(num1)
	if num2 ~= 0 then 
		runeTxt = runeTxt.."."..string.sub(tostring(num2), 3, 3)
	end
	return runeTxt
end

function ShowGearScore(aParams)
	if aParams.unitId == avatar.GetTarget() then
		local txt = CreateValuedText(RuneToTxt(aParams.runesQualityOffensive), ":", RuneToTxt(aParams.runesQualityDefensive), aParams.runesStyleOffensive, "", aParams.runesStyleDefensive)
		m_runeTxtWidget:SetValuedText(txt)

		txt = CreateValuedText(aParams.fairy, "", "", aParams.fairyStyle, "", "")
		m_fairyTxtWidget:SetValuedText(txt)

		txt = CreateValuedText(tostring(math.floor(aParams.gearscore)), "", "", aParams.gearscoreStyle, "", "")
		m_gsTxtWidget:SetValuedText(txt)
		show(mainForm)
	end
end

function Init()
	if GS.Init then GS.Init() end
	
	m_template = getChild(mainForm, "Template")
	setTemplateWidget(m_template)
	m_myMainForm =  mainForm:GetChildChecked("MainPanel", false)
	DnD:Init(m_myMainForm, m_myMainForm, true)
	
	m_runeTxtWidget = createWidget(m_myMainForm, "runeHeader", "TextView", nil, nil, 66, 25, 0, 9)
	m_gsTxtWidget = createWidget(m_myMainForm, "runeHeader", "TextView", nil, nil, 70, 25, 70, 9)
	m_fairyTxtWidget = createWidget(m_myMainForm, "runeHeader", "TextView", nil, nil, 134, 25, 0, 9)
	
	
	hide(mainForm)
	
	common.RegisterEventHandler( OnTargetChaged, "EVENT_AVATAR_TARGET_CHANGED")
	common.RegisterEventHandler( ShowGearScore, "LIBGS_GEARSCORE_AVAILABLE")
	
	GS.Callback = ShowGearScore
	GS.EnableTargetInspection( true )
end

if (avatar.IsExist()) then
	Init()
else
	common.RegisterEventHandler(Init, "EVENT_AVATAR_CREATED")
end
