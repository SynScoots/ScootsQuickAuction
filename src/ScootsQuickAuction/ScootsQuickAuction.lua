SQA = {}
SQA.loaded = false
SQA.active = false
SQA.activeItem = nil
SQA.options = {}
SQA.optionsRendered = false
SQA.optionsOpen = false
SQA.frames = {}
SQA.frames.master = CreateFrame('Frame', 'ScootsQuickAuctionMasterFrame', UIParent)

function ScootsQuickAuction_RegisterTTH(tooltip)
    SQA.TTH = tooltip
end

function SQA.openAuctionHouse()
    if(SQA.loaded == false) then
        SQA.buttons = {}
        SQA.buttons.toggleOptions = CreateFrame('Button', 'ScootsQuickAuctionOptionsButton', _G['AuctionFrameAuctions'], 'UIPanelButtonTemplate2')
        SQA.buttons.toggleOptions:SetSize(150, 22)
        SQA.buttons.toggleOptions:SetText('ScootsQuickAuctions')
        SQA.buttons.toggleOptions:SetPoint('BOTTOMLEFT', _G['AuctionFrameAuctions'], 'BOTTOMLEFT', 210, 15)
        SQA.buttons.toggleOptions:SetFrameStrata('HIGH')
        SQA.buttons.toggleOptions:SetScript('OnClick', SQA.clickOptionsButton)
        
        SQA.buttons.toggleState = CreateFrame('Button', 'ScootsQuickAuctionStateButton', _G['AuctionFrameAuctions'], 'UIPanelButtonTemplate2')
        SQA.buttons.toggleState:SetSize(100, 22)
        SQA.buttons.toggleState:SetText('Quick List: off')
        SQA.buttons.toggleState:SetPoint('BOTTOMLEFT', SQA.buttons.toggleOptions, 'BOTTOMRIGHT', -3, 0)
        SQA.buttons.toggleState:SetFrameStrata('HIGH')
        SQA.buttons.toggleState:SetScript('OnClick', SQA.clickStateButton)
        
        _G['AuctionsItemButton']:SetScript('OnEvent', SQA.doAuctionEvent)
        
        SQA.frames.master:SetScript('OnUpdate', function()
            if(SQA.active == true and _G['AuctionFrameAuctions']:IsVisible()) then
                local _, itemLink = GameTooltip:GetItem()
                
                if(itemLink ~= nil and SQA.activeItem ~= itemLink) then
                    SQA.activeItem = itemLink
                end
            end
        end)

        local old_AuctionFrameBrowse_Update = AuctionFrameBrowse_Update
        AuctionFrameBrowse_Update = function(...)
            old_AuctionFrameBrowse_Update(...)
            SQA.setForgedIconsOnBrowse()
        end
        
        local old_AuctionFrameBid_Update = AuctionFrameBid_Update
        AuctionFrameBid_Update = function(...)
            old_AuctionFrameBid_Update(...)
            SQA.setForgedIconsOnBids()
        end
        
        local old_AuctionFrameAuctions_Update = AuctionFrameAuctions_Update
        AuctionFrameAuctions_Update = function(...)
            old_AuctionFrameAuctions_Update(...)
            SQA.setForgedIconsOnAuctions()
        end
        
        SQA.loaded = true
    end
end

function SQA.closeAuctionHouse()
    if(SQA.optionsOpen == true) then
        SQA.clickOptionsButton()
    end
end

function SQA.clickOptionsButton()
    if(SQA.optionsRendered == false) then
        SQA.renderOptions()
    end
    
    local auctionFrames = {
        'AuctionsQualitySort',
        'AuctionsDurationSort',
        'AuctionsHighBidderSort',
        'AuctionsBidSort',
        'AuctionsScrollFrame',
        'AuctionsScrollFrameScrollChildFrame',
        'AuctionsCancelAuctionButton'
    }
    
    local auctionListingFrames = {
        'AuctionsButton1',
        'AuctionsButton2',
        'AuctionsButton3',
        'AuctionsButton4',
        'AuctionsButton5',
        'AuctionsButton6',
        'AuctionsButton7',
        'AuctionsButton8',
        'AuctionsButton9'
    }
    
    local auctionScrollBarFrames = {
        'AuctionsScrollFrameScrollBar',
        'AuctionsScrollFrameScrollBarScrollUpButton',
        'AuctionsScrollFrameScrollBarScrollDownButton'
    }
    
    if(SQA.optionsOpen == false) then
        for _, frameName in pairs(auctionFrames) do
            if(_G[frameName] ~= nil) then
                _G[frameName]:Hide()
            end
        end
        
        for _, frameName in pairs(auctionListingFrames) do
            if(_G[frameName] ~= nil) then
                _G[frameName]:Hide()
            end
        end
        
        for _, frameName in pairs(auctionScrollBarFrames) do
            if(_G[frameName] ~= nil) then
                _G[frameName]:Hide()
            end
        end
        
        SQA.frames.optionsMaster:Show()
        SQA.optionsOpen = true
    
        local levels = {
            'Unforged',
            'Titanforged',
            'Warforged',
            'Lightforged'
        }
        
        local subLevels = {
            'Regular',
            'Mythic'
        }
    
        local baseLevel = _G['AuctionFrameAuctions']:GetFrameLevel()
        SQA.frames.optionsMaster:SetFrameLevel(baseLevel + 1)
        
        for _, level in pairs(levels) do
            SQA.frames['options' .. level .. 'Header']:SetFrameLevel(baseLevel + 2)
            SQA.frames['options' .. level .. 'BidHeader']:SetFrameLevel(baseLevel + 2)
            SQA.frames['options' .. level .. 'BuyHeader']:SetFrameLevel(baseLevel + 2)
            
            for _, subLevel in pairs(subLevels) do
                SQA.frames['options' .. level .. subLevel .. 'SubHeader']:SetFrameLevel(baseLevel + 2)
                
                SQA.frames['options' .. level .. subLevel .. 'Bid']:SetFrameLevel(baseLevel + 2)
                SQA.frames['options' .. level .. subLevel .. 'Bid'].gold:SetFrameLevel(baseLevel + 3)
                SQA.frames['options' .. level .. subLevel .. 'Bid'].silver:SetFrameLevel(baseLevel + 3)
                SQA.frames['options' .. level .. subLevel .. 'Bid'].copper:SetFrameLevel(baseLevel + 3)
                
                SQA.frames['options' .. level .. subLevel .. 'Buy']:SetFrameLevel(baseLevel + 2)
                SQA.frames['options' .. level .. subLevel .. 'Buy'].gold:SetFrameLevel(baseLevel + 3)
                SQA.frames['options' .. level .. subLevel .. 'Buy'].silver:SetFrameLevel(baseLevel + 3)
                SQA.frames['options' .. level .. subLevel .. 'Buy'].copper:SetFrameLevel(baseLevel + 3)
                
                SQA.frames['options' .. level .. subLevel .. 'Toggle']:SetFrameLevel(baseLevel + 2)
                SQA.frames['options' .. level .. subLevel .. 'Toggle'].checkBorder:SetFrameLevel(baseLevel + 3)
                SQA.frames['options' .. level .. subLevel .. 'Toggle'].check:SetFrameLevel(baseLevel + 3)
            end
        end
    else
        for _, frameName in pairs(auctionFrames) do
            if(_G[frameName] ~= nil) then
                _G[frameName]:Show()
            end
        end
        
        local _, numAuctions = GetNumAuctionItems('owner')
        for index, frameName in pairs(auctionListingFrames) do
            if(index > numAuctions) then
                break
            end
        
            if(_G[frameName] ~= nil) then
                _G[frameName]:Show()
            end
        end
        
        if(numAuctions > 9) then
            for _, frameName in pairs(auctionScrollBarFrames) do
                if(_G[frameName] ~= nil) then
                    _G[frameName]:Show()
                end
            end
        end
        
        SQA.setOptions()
        SQA.frames.optionsMaster:Hide()
        SQA.optionsOpen = false
    end
end

function SQA.renderOptions()
    SQA.frames.optionsMaster = CreateFrame('Frame', 'ScootsQuickAuctionOptionsMasterFrame', _G['AuctionFrameAuctions'])
    SQA.frames.optionsMaster:SetFrameStrata('MEDIUM')
    SQA.frames.optionsMaster:SetWidth(606)
    SQA.frames.optionsMaster:SetHeight(334)
    SQA.frames.optionsMaster:SetPoint('TOPLEFT', _G['AuctionFrameAuctions'], 'TOPLEFT', 216, -73)
    
    local levels = {
        'Unforged',
        'Titanforged',
        'Warforged',
        'Lightforged'
    }
    
    local subLevels = {
        'Regular',
        'Mythic'
    }
    
    local anchorPoint = nil
    for _, level in pairs(levels) do
        local key = 'ScootsQuickAuctionOptions' .. level
        
        -- Level header
        SQA.frames['options' .. level .. 'Header'] = CreateFrame('Frame', key .. 'Header', SQA.frames.optionsMaster)
        SQA.frames['options' .. level .. 'Header']:SetFrameStrata('MEDIUM')
        SQA.frames['options' .. level .. 'Header']:SetWidth(SQA.frames.optionsMaster:GetWidth() - 10)
        SQA.frames['options' .. level .. 'Header']:SetHeight(12)
        SQA.frames['options' .. level .. 'Header'].text = SQA.frames['options' .. level .. 'Header']:CreateFontString(nil, 'ARTWORK')
        SQA.frames['options' .. level .. 'Header'].text:SetFont('Fonts\\FRIZQT__.TTF', 12)
        SQA.frames['options' .. level .. 'Header'].text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
        SQA.frames['options' .. level .. 'Header'].text:SetHeight(12)
        SQA.frames['options' .. level .. 'Header'].text:SetAllPoints()
        SQA.frames['options' .. level .. 'Header'].text:SetJustifyH('LEFT')
        SQA.frames['options' .. level .. 'Header'].text:SetText(level)
        
        if(anchorPoint == nil) then
            SQA.frames['options' .. level .. 'Header']:SetPoint('TOPLEFT', SQA.frames.optionsMaster, 'TOPLEFT', 5, -5)
        else
            SQA.frames['options' .. level .. 'Header']:SetPoint('TOPLEFT', anchorPoint, 'BOTTOMLEFT', 0, -24)
        end
        
        anchorPoint = SQA.frames['options' .. level .. 'Header']
        
        for _, subLevel in pairs(subLevels) do
            local suffix = ''
            local stepDown = -20
            if(subLevel == 'Mythic') then
                suffix = '-mythic'
                stepDown = -10
            end
        
            -- Sublevel header
            SQA.frames['options' .. level .. subLevel .. 'SubHeader'] = CreateFrame('Frame', key .. subLevel .. 'SubHeader', SQA.frames.optionsMaster)
            SQA.frames['options' .. level .. subLevel .. 'SubHeader']:SetFrameStrata('MEDIUM')
            SQA.frames['options' .. level .. subLevel .. 'SubHeader']:SetWidth(45)
            SQA.frames['options' .. level .. subLevel .. 'SubHeader']:SetHeight(10)
            SQA.frames['options' .. level .. subLevel .. 'SubHeader']:SetPoint('TOPLEFT', anchorPoint, 'BOTTOMLEFT', 0, stepDown)
            SQA.frames['options' .. level .. subLevel .. 'SubHeader'].text = SQA.frames['options' .. level .. subLevel .. 'SubHeader']:CreateFontString(nil, 'ARTWORK')
            SQA.frames['options' .. level .. subLevel .. 'SubHeader'].text:SetFont('Fonts\\FRIZQT__.TTF', 10)
            SQA.frames['options' .. level .. subLevel .. 'SubHeader'].text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
            SQA.frames['options' .. level .. subLevel .. 'SubHeader'].text:SetHeight(10)
            SQA.frames['options' .. level .. subLevel .. 'SubHeader'].text:SetAllPoints()
            SQA.frames['options' .. level .. subLevel .. 'SubHeader'].text:SetJustifyH('LEFT')
            SQA.frames['options' .. level .. subLevel .. 'SubHeader'].text:SetText(subLevel)
            
            anchorPoint = SQA.frames['options' .. level .. subLevel .. 'SubHeader']
            
            -- Bid input
            SQA.frames['options' .. level .. subLevel .. 'Bid'] = CreateFrame('EditBox', key .. subLevel .. 'Bid', SQA.frames.optionsMaster, 'MoneyInputFrameTemplate')
            SQA.frames['options' .. level .. subLevel .. 'Bid']:SetPoint('TOPLEFT', SQA.frames['options' .. level .. subLevel .. 'SubHeader'], 'TOPRIGHT', 5, 3)
            SQA.frames['options' .. level .. subLevel .. 'Bid']:SetFrameStrata('MEDIUM')
            SQA.frames['options' .. level .. subLevel .. 'Bid']:SetMaxLetters(2)
            SQA.frames['options' .. level .. subLevel .. 'Bid']:SetHeight(20)
            SQA.frames['options' .. level .. subLevel .. 'Bid']:SetMovable(false)
            SQA.frames['options' .. level .. subLevel .. 'Bid']:SetAutoFocus(false)
            SQA.frames['options' .. level .. subLevel .. 'Bid'].gold:SetMaxLetters(6)
            SQA.frames['options' .. level .. subLevel .. 'Bid'].silver:SetMaxLetters(2)
            SQA.frames['options' .. level .. subLevel .. 'Bid'].copper:SetMaxLetters(2)
            
            SQA.frames['options' .. level .. subLevel .. 'Bid'].gold:SetNumber(SQA.options[level .. suffix].bidG)
            SQA.frames['options' .. level .. subLevel .. 'Bid'].silver:SetNumber(SQA.options[level .. suffix].bidS)
            SQA.frames['options' .. level .. subLevel .. 'Bid'].copper:SetNumber(SQA.options[level .. suffix].bidC)
            
            -- Bid header
            if(subLevel ~= 'Mythic') then
                SQA.frames['options' .. level .. 'BidHeader'] = CreateFrame('Frame', key .. subLevel .. 'BidHeader', SQA.frames.optionsMaster)
                SQA.frames['options' .. level .. 'BidHeader']:SetPoint('BOTTOMLEFT', SQA.frames['options' .. level .. subLevel .. 'Bid'], 'TOPLEFT', -5, 2)
                SQA.frames['options' .. level .. 'BidHeader']:SetFrameStrata('MEDIUM')
                SQA.frames['options' .. level .. 'BidHeader']:SetWidth(100)
                SQA.frames['options' .. level .. 'BidHeader']:SetHeight(10)
                SQA.frames['options' .. level .. 'BidHeader'].text = SQA.frames['options' .. level .. 'BidHeader']:CreateFontString(nil, 'ARTWORK')
                SQA.frames['options' .. level .. 'BidHeader'].text:SetFont('Fonts\\FRIZQT__.TTF', 10)
                SQA.frames['options' .. level .. 'BidHeader'].text:SetHeight(10)
                SQA.frames['options' .. level .. 'BidHeader'].text:SetAllPoints()
                SQA.frames['options' .. level .. 'BidHeader'].text:SetJustifyH('LEFT')
                SQA.frames['options' .. level .. 'BidHeader'].text:SetText('Starting Price')
            end
            
            -- Buy input
            SQA.frames['options' .. level .. subLevel .. 'Buy'] = CreateFrame('EditBox', key .. subLevel .. 'Buy', SQA.frames.optionsMaster, 'MoneyInputFrameTemplate')
            SQA.frames['options' .. level .. subLevel .. 'Buy']:SetPoint('TOPLEFT', SQA.frames['options' .. level .. subLevel .. 'Bid'], 'TOPRIGHT', 10, 0)
            SQA.frames['options' .. level .. subLevel .. 'Buy']:SetFrameStrata('MEDIUM')
            SQA.frames['options' .. level .. subLevel .. 'Buy']:SetMaxLetters(2)
            SQA.frames['options' .. level .. subLevel .. 'Buy']:SetHeight(20)
            SQA.frames['options' .. level .. subLevel .. 'Buy']:SetMovable(false)
            SQA.frames['options' .. level .. subLevel .. 'Buy']:SetAutoFocus(false)
            SQA.frames['options' .. level .. subLevel .. 'Buy'].gold:SetMaxLetters(6)
            SQA.frames['options' .. level .. subLevel .. 'Buy'].silver:SetMaxLetters(2)
            SQA.frames['options' .. level .. subLevel .. 'Buy'].copper:SetMaxLetters(2)
            
            SQA.frames['options' .. level .. subLevel .. 'Buy'].gold:SetNumber(SQA.options[level .. suffix].buyG)
            SQA.frames['options' .. level .. subLevel .. 'Buy'].silver:SetNumber(SQA.options[level .. suffix].buyS)
            SQA.frames['options' .. level .. subLevel .. 'Buy'].copper:SetNumber(SQA.options[level .. suffix].buyC)
            
            -- Buy header
            if(subLevel ~= 'Mythic') then
                SQA.frames['options' .. level .. 'BuyHeader'] = CreateFrame('Frame', key .. 'BuyHeader', SQA.frames.optionsMaster)
                SQA.frames['options' .. level .. 'BuyHeader']:SetPoint('BOTTOMLEFT', SQA.frames['options' .. level .. subLevel .. 'Buy'], 'TOPLEFT', -5, 2)
                SQA.frames['options' .. level .. 'BuyHeader']:SetFrameStrata('MEDIUM')
                SQA.frames['options' .. level .. 'BuyHeader']:SetWidth(100)
                SQA.frames['options' .. level .. 'BuyHeader']:SetHeight(10)
                SQA.frames['options' .. level .. 'BuyHeader'].text = SQA.frames['options' .. level .. 'BuyHeader']:CreateFontString(nil, 'ARTWORK')
                SQA.frames['options' .. level .. 'BuyHeader'].text:SetFont('Fonts\\FRIZQT__.TTF', 10)
                SQA.frames['options' .. level .. 'BuyHeader'].text:SetHeight(10)
                SQA.frames['options' .. level .. 'BuyHeader'].text:SetAllPoints()
                SQA.frames['options' .. level .. 'BuyHeader'].text:SetJustifyH('LEFT')
                SQA.frames['options' .. level .. 'BuyHeader'].text:SetText('Buyout Price')
            end
            
            -- Enabled check
            SQA.frames['options' .. level .. subLevel .. 'Toggle'] = CreateFrame('Frame', key .. subLevel .. 'Enabled', SQA.frames.optionsMaster)
            SQA.frames['options' .. level .. subLevel .. 'Toggle'].level = level
            SQA.frames['options' .. level .. subLevel .. 'Toggle'].suffix = suffix
            SQA.frames['options' .. level .. subLevel .. 'Toggle']:SetPoint('TOPLEFT', SQA.frames['options' .. level .. subLevel .. 'Buy'], 'TOPRIGHT', 0, -2)
            SQA.frames['options' .. level .. subLevel .. 'Toggle']:SetFrameStrata('MEDIUM')
            SQA.frames['options' .. level .. subLevel .. 'Toggle']:SetHeight(18)
            SQA.frames['options' .. level .. subLevel .. 'Toggle'].text = SQA.frames['options' .. level .. subLevel .. 'Toggle']:CreateFontString(nil, 'ARTWORK')
            SQA.frames['options' .. level .. subLevel .. 'Toggle'].text:SetFont('Fonts\\FRIZQT__.TTF', 10)
            SQA.frames['options' .. level .. subLevel .. 'Toggle'].text:SetPoint('LEFT', 18, 0)
            SQA.frames['options' .. level .. subLevel .. 'Toggle'].text:SetJustifyH('LEFT')
            SQA.frames['options' .. level .. subLevel .. 'Toggle'].text:SetTextColor(1, 1, 1)
            SQA.frames['options' .. level .. subLevel .. 'Toggle'].text:SetText('Enabled')
            SQA.frames['options' .. level .. subLevel .. 'Toggle']:SetWidth(SQA.frames['options' .. level .. subLevel .. 'Toggle'].text:GetStringWidth() + 20)
            SQA.frames['options' .. level .. subLevel .. 'Toggle']:EnableMouse(true)
            
            SQA.frames['options' .. level .. subLevel .. 'Toggle'].checkBorder = CreateFrame('Frame', key .. 'EnabledCheckBorder', SQA.frames['options' .. level .. subLevel .. 'Toggle'])
            SQA.frames['options' .. level .. subLevel .. 'Toggle'].checkBorder:SetFrameStrata('MEDIUM')
            SQA.frames['options' .. level .. subLevel .. 'Toggle'].checkBorder:SetSize(18, 18)
            SQA.frames['options' .. level .. subLevel .. 'Toggle'].checkBorder:SetPoint('TOPLEFT', SQA.frames['options' .. level .. subLevel .. 'Toggle'], 'TOPLEFT', -2, -1)
            SQA.frames['options' .. level .. subLevel .. 'Toggle'].checkBorder.texture = SQA.frames['options' .. level .. subLevel .. 'Toggle'].checkBorder:CreateTexture()
            SQA.frames['options' .. level .. subLevel .. 'Toggle'].checkBorder.texture:SetAllPoints()
            SQA.frames['options' .. level .. subLevel .. 'Toggle'].checkBorder.texture:SetTexture('Interface/AchievementFrame/UI-Achievement-Progressive-IconBorder')
            SQA.frames['options' .. level .. subLevel .. 'Toggle'].checkBorder.texture:SetTexCoord(0, 0.65625, 0, 0.65625)
            SQA.frames['options' .. level .. subLevel .. 'Toggle'].checkBorder:SetAlpha(0.8)
            
            SQA.frames['options' .. level .. subLevel .. 'Toggle'].check = CreateFrame('Frame', key .. 'EnabledCheck', SQA.frames['options' .. level .. subLevel .. 'Toggle'])
            SQA.frames['options' .. level .. subLevel .. 'Toggle'].check:SetFrameStrata('MEDIUM')
            SQA.frames['options' .. level .. subLevel .. 'Toggle'].check:SetSize(18, 18)
            SQA.frames['options' .. level .. subLevel .. 'Toggle'].check:SetPoint('TOPLEFT', SQA.frames['options' .. level .. subLevel .. 'Toggle'], 'TOPLEFT', -2, -2)
            SQA.frames['options' .. level .. subLevel .. 'Toggle'].check.texture = SQA.frames['options' .. level .. subLevel .. 'Toggle'].check:CreateTexture()
            SQA.frames['options' .. level .. subLevel .. 'Toggle'].check.texture:SetAllPoints()
            SQA.frames['options' .. level .. subLevel .. 'Toggle'].check.texture:SetTexture('Interface/AchievementFrame/UI-Achievement-Criteria-Check')
            SQA.frames['options' .. level .. subLevel .. 'Toggle'].check.texture:SetTexCoord(0, 0.65625, 0, 1)
            
            if(SQA.options[level .. suffix].enabled ~= true) then
                SQA.frames['options' .. level .. subLevel .. 'Toggle'].check:Hide()
            end
            
            SQA.frames['options' .. level .. subLevel .. 'Toggle']:SetScript('OnEnter', function(self)
                self.checkBorder:SetAlpha(1)
            end)
            
            SQA.frames['options' .. level .. subLevel .. 'Toggle']:SetScript('OnLeave', function(self)
                self.checkBorder:SetAlpha(0.8)
            end)
            
            SQA.frames['options' .. level .. subLevel .. 'Toggle']:SetScript('OnMouseDown', function(self, button)
                if(button == 'LeftButton') then
                    if(SQA.options[self.level .. self.suffix].enabled == true) then
                        self.check:Hide()
                        SQA.options[self.level .. self.suffix].enabled = false
                    else
                        self.check:Show()
                        SQA.options[self.level .. self.suffix].enabled = true
                    end
                end
            end)
        end
    end
    
    SQA.optionsRendered = true
end

function SQA.clickStateButton()
    if(SQA.active == true) then
        SQA.buttons.toggleState:SetText('Quick List: off')
        SQA.active = false
    else
        SQA.buttons.toggleState:SetText('Quick List: on')
        SQA.active = true
    end
end

function SQA.setOptions()
    if(SQA.optionsRendered == false) then
        return
    end
    
    local levels = {
        'Unforged',
        'Titanforged',
        'Warforged',
        'Lightforged'
    }
    
    for _, level in pairs(levels) do
        SQA.options[level].bidG = SQA.frames['options' .. level .. 'RegularBid'].gold:GetNumber()
        SQA.options[level].bidS = SQA.frames['options' .. level .. 'RegularBid'].silver:GetNumber()
        SQA.options[level].bidC = SQA.frames['options' .. level .. 'RegularBid'].copper:GetNumber()
        SQA.options[level].buyG = SQA.frames['options' .. level .. 'RegularBuy'].gold:GetNumber()
        SQA.options[level].buyS = SQA.frames['options' .. level .. 'RegularBuy'].silver:GetNumber()
        SQA.options[level].buyC = SQA.frames['options' .. level .. 'RegularBuy'].copper:GetNumber()
        
        SQA.options[level .. '-mythic'].bidG = SQA.frames['options' .. level .. 'MythicBid'].gold:GetNumber()
        SQA.options[level .. '-mythic'].bidS = SQA.frames['options' .. level .. 'MythicBid'].silver:GetNumber()
        SQA.options[level .. '-mythic'].bidC = SQA.frames['options' .. level .. 'MythicBid'].copper:GetNumber()
        SQA.options[level .. '-mythic'].buyG = SQA.frames['options' .. level .. 'MythicBuy'].gold:GetNumber()
        SQA.options[level .. '-mythic'].buyS = SQA.frames['options' .. level .. 'MythicBuy'].silver:GetNumber()
        SQA.options[level .. '-mythic'].buyC = SQA.frames['options' .. level .. 'MythicBuy'].copper:GetNumber()
    end
    
    _G['SQA_OPTIONS'] = SQA.options
end

function SQA.itemIsMythic(itemLink)
    SQA.TTH:ClearLines()
    SQA.TTH:SetOwner(UIParent)
    SQA.TTH:SetHyperlink(itemLink)
    
    for _, line in ipairs({SQA.TTH:GetRegions()}) do
        if(line:IsObjectType('FontString')) then
            if(line:GetText() == 'Mythic') then
                SQA.TTH:Hide()
                return true
            end
        end
    end
    
    SQA.TTH:Hide()
    
    return false
end

function SQA.doAuctionEvent(self, event, ...)
    AuctionSellItemButton_OnEvent(self, event)
    if(SQA.active == true) then
        if(event == 'NEW_AUCTION_UPDATE') then
            if(not GetAuctionSellItemInfo()) then
                return
            end
            
            local levels = {'Titanforged', 'Warforged', 'Lightforged'}
            
            local forge = GetItemLinkTitanforge(SQA.activeItem)
            local level = 'Unforged'
            if(levels[forge] ~= nil) then
                level = levels[forge]
            end
            
            if(SQA.itemIsMythic(SQA.activeItem)) then
                level = level .. '-mythic'
            end
            
            if(SQA.options[level].enabled == true) then
                _G['StartPriceGold']:SetNumber(SQA.options[level].bidG)
                _G['StartPriceSilver']:SetNumber(SQA.options[level].bidS)
                _G['StartPriceCopper']:SetNumber(SQA.options[level].bidC)
                
                _G['BuyoutPriceGold']:SetNumber(SQA.options[level].buyG)
                _G['BuyoutPriceSilver']:SetNumber(SQA.options[level].buyS)
                _G['BuyoutPriceCopper']:SetNumber(SQA.options[level].buyC)
                
                _G['AuctionsCreateAuctionButton']:Click()
            end
        end
    end
end

function SQA.setForgedIconsOnBrowse()
    for i = 1, 8 do
        local frame = _G['BrowseButton' .. tostring(i) .. 'Item']
        local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)
        local index = offset + i
        
        if(frame and frame:IsVisible()) then
            SQA.setForgedIconOnFrame(frame, 'list', index)
        end
    end
end

function SQA.setForgedIconsOnBids()
    for i = 1, 9 do
        local frame = _G['BidButton' .. tostring(i) .. 'Item']
        local offset = FauxScrollFrame_GetOffset(BidScrollFrame)
        local index = offset + i
        
        if(frame and frame:IsVisible()) then
            SQA.setForgedIconOnFrame(frame, 'bidder', index)
        end
    end
end

function SQA.setForgedIconsOnAuctions()
    for i = 1, 9 do
        local frame = _G['AuctionsButton' .. tostring(i) .. 'Item']
        local offset = FauxScrollFrame_GetOffset(AuctionsScrollFrame);
        local index = offset + i
        
        if(frame and frame:IsVisible()) then
            SQA.setForgedIconOnFrame(frame, 'owner', index)
        end
    end
end

function SQA.setForgedIconOnFrame(itemFrame, auctionType, index)
    local frameName = itemFrame:GetName() .. 'ForgedIcon'
    
    if(not _G[frameName]) then
        CreateFrame('Frame', frameName, itemFrame)
        
        _G[frameName]:SetPoint('TOPRIGHT', itemFrame, 'TOPRIGHT', 0, -1.25)
        _G[frameName]:SetWidth(7)
        _G[frameName]:SetHeight(7)
        _G[frameName]:SetScale(4)
        _G[frameName]:SetFrameLevel(itemFrame:GetFrameLevel() + 1)
    
        _G[frameName].text = _G[frameName]:CreateFontString(nil, 'ARTWORK')
        _G[frameName].text:SetFont([[Interface\AddOns\ScootsQuickAuction\Fonts\dfdrsp__.TTF]], 3, 'THICKOUTLINE')
        _G[frameName].text:SetPoint('TOPRIGHT', 0, 0)
        _G[frameName].text:SetJustifyH('RIGHT')
        _G[frameName].text:SetShadowOffset(0, 0)
        _G[frameName].text:SetShadowColor(0.1, 0.1, 0.1, 1)
    end
    
    _G[frameName]:Hide()
    
    local itemLink = GetAuctionItemLink(auctionType, index)
    
    if(itemLink and GetItemLinkTitanforge) then
        local forgedLevel = GetItemLinkTitanforge(itemLink)
        
        if(forgedLevel > 0) then
            if(forgedLevel == 1) then
                _G[frameName].text:SetTextColor(0.5, 0.5, 1)
                _G[frameName].text:SetText('T')
            elseif(forgedLevel == 2) then
                _G[frameName].text:SetTextColor(1, 0.65, 0.5)
                _G[frameName].text:SetText('W')
            else
                _G[frameName].text:SetTextColor(1, 1, 0.65)
                _G[frameName].text:SetText('L')
            end
            
            _G[frameName]:Show()
        end
    end
end

function SQA.onLoad()
    if(_G['SQA_OPTIONS'] == nil or _G['SQA_OPTIONS'].Unforged == nil) then
        local newOptions = {
            ['Unforged'] = {
                ['enabled'] = true,
                ['bidG'] = 75,
                ['bidS'] = 0,
                ['bidC'] = 0,
                ['buyG'] = 100,
                ['buyS'] = 0,
                ['buyC'] = 0
            }
        }
    
        if(_G['SQA_OPTIONS'] ~= nil) then
            if(_G['SQA_OPTIONS'].bidGold ~= nil) then
                newOptions.Unforged.bidG = _G['SQA_OPTIONS'].bidGold
            end
            if(_G['SQA_OPTIONS'].bidSilver ~= nil) then
                newOptions.Unforged.bidS = _G['SQA_OPTIONS'].bidSilver
            end
            if(_G['SQA_OPTIONS'].bidCopper ~= nil) then
                newOptions.Unforged.bidC = _G['SQA_OPTIONS'].bidCopper
            end
            if(_G['SQA_OPTIONS'].buyGold ~= nil) then
                newOptions.Unforged.buyG = _G['SQA_OPTIONS'].buyGold
            end
            if(_G['SQA_OPTIONS'].buySilver ~= nil) then
                newOptions.Unforged.buyS = _G['SQA_OPTIONS'].buySilver
            end
            if(_G['SQA_OPTIONS'].buyCopper ~= nil) then
                newOptions.Unforged.buyC = _G['SQA_OPTIONS'].buyCopper
            end
        end
        
        _G['SQA_OPTIONS'] = newOptions
    end
    
    local levels = {
        'Unforged',
        'Unforged-mythic',
        'Titanforged',
        'Titanforged-mythic',
        'Warforged',
        'Warforged-mythic',
        'Lightforged',
        'Lightforged-mythic'
    }
    
    local values = {
        'enabled',
        'bidG',
        'bidS',
        'bidC',
        'buyG',
        'buyS',
        'buyC'
    }
    
    SQA.options = {}
    for _, level in pairs(levels) do
        SQA.options[level] = {}
        
        SQA.options[level].enabled = false
        if(level == 'Unforged') then
            SQA.options[level].enabled = true
        end
        
        for _, value in pairs(values) do
            if(value ~= 'enabled') then
                SQA.options[level][value] = ''
            end
            
            if(_G['SQA_OPTIONS'][level] ~= nil and _G['SQA_OPTIONS'][level][value] ~= nil) then
                SQA.options[level][value] = _G['SQA_OPTIONS'][level][value]
            end
        end
    end
end

function SQA.onLogout()
    _G['SQA_OPTIONS'] = SQA.options
end

function SQA.eventHandler(self, event, arg1)
    if(event == 'ADDON_LOADED' and arg1 == 'ScootsQuickAuction') then
        SQA.onLoad()
    elseif(event == 'AUCTION_HOUSE_SHOW') then
        SQA.openAuctionHouse()
    elseif(event == 'AUCTION_HOUSE_CLOSED') then
        SQA.closeAuctionHouse()
    end
end

SQA.frames.master:SetScript('OnEvent', SQA.eventHandler)
SQA.frames.master:RegisterEvent('AUCTION_HOUSE_SHOW')
SQA.frames.master:RegisterEvent('AUCTION_HOUSE_CLOSED')
SQA.frames.master:RegisterEvent('ADDON_LOADED')