SQA = {}
SQA.loaded = false
SQA.active = false
SQA.activeItem = nil
SQA.options = {}
SQA.optionsRendered = false
SQA.optionsOpen = false
SQA.frames = {}
SQA.frames.master = CreateFrame('Frame', 'ScootsQuickAuctionMasterFrame', UIParent)

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
        'AuctionsScrollFrameScrollBar',
        'AuctionsScrollFrameScrollBarScrollUpButton',
        'AuctionsScrollFrameScrollBarScrollDownButton',
        'AuctionsButton1',
        'AuctionsButton2',
        'AuctionsButton3',
        'AuctionsButton4',
        'AuctionsButton5',
        'AuctionsButton6',
        'AuctionsButton7',
        'AuctionsButton8',
        'AuctionsButton9',
        'AuctionsCancelAuctionButton'
    }
    
    if(SQA.optionsOpen == false) then
        for _, frameName in pairs(auctionFrames) do
            if(_G[frameName] ~= nil) then
                _G[frameName]:Hide()
            end
            
            SQA.frames.optionsMaster:Show()
        end
        
        SQA.optionsOpen = true
    else
        for _, frameName in pairs(auctionFrames) do
            if(_G[frameName] ~= nil) then
                _G[frameName]:Show()
            end
            
            SQA.frames.optionsMaster:Hide()
            SQA.setOptions()
        end
        
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
    
    local anchorPoint = nil
    for _, level in pairs(levels) do
        local key = 'ScootsQuickAuctionOptions' .. level
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
            SQA.frames['options' .. level .. 'Header']:SetPoint('TOPLEFT', anchorPoint, 'BOTTOMLEFT', -5, -20)
        end
        
        ----

        SQA.frames['options' .. level .. 'Toggle'] = CreateFrame('Frame', key .. 'Enabled', SQA.frames.optionsMaster)
        SQA.frames['options' .. level .. 'Toggle'].level = level
        SQA.frames['options' .. level .. 'Toggle']:SetPoint('TOPLEFT', SQA.frames['options' .. level .. 'Header'], 'BOTTOMLEFT', 0, -2)
        SQA.frames['options' .. level .. 'Toggle']:SetFrameStrata('MEDIUM')
        SQA.frames['options' .. level .. 'Toggle']:SetHeight(18)
        SQA.frames['options' .. level .. 'Toggle'].text = SQA.frames['options' .. level .. 'Toggle']:CreateFontString(nil, 'ARTWORK')
        SQA.frames['options' .. level .. 'Toggle'].text:SetFont('Fonts\\FRIZQT__.TTF', 10)
        SQA.frames['options' .. level .. 'Toggle'].text:SetPoint('LEFT', 18, 0)
        SQA.frames['options' .. level .. 'Toggle'].text:SetJustifyH('LEFT')
        SQA.frames['options' .. level .. 'Toggle'].text:SetTextColor(1, 1, 1)
        SQA.frames['options' .. level .. 'Toggle'].text:SetText('Enabled')
        SQA.frames['options' .. level .. 'Toggle']:SetWidth(SQA.frames['options' .. level .. 'Toggle'].text:GetStringWidth() + 20)
        SQA.frames['options' .. level .. 'Toggle']:EnableMouse(true)
        
        SQA.frames['options' .. level .. 'Toggle'].checkBorder = CreateFrame('Frame', key .. 'EnabledCheckBorder', SQA.frames['options' .. level .. 'Toggle'])
        SQA.frames['options' .. level .. 'Toggle'].checkBorder:SetFrameStrata('MEDIUM')
        SQA.frames['options' .. level .. 'Toggle'].checkBorder:SetSize(18, 18)
        SQA.frames['options' .. level .. 'Toggle'].checkBorder:SetPoint('TOPLEFT', SQA.frames['options' .. level .. 'Toggle'], 'TOPLEFT', -2, -1)
        SQA.frames['options' .. level .. 'Toggle'].checkBorder.texture = SQA.frames['options' .. level .. 'Toggle'].checkBorder:CreateTexture()
        SQA.frames['options' .. level .. 'Toggle'].checkBorder.texture:SetAllPoints()
        SQA.frames['options' .. level .. 'Toggle'].checkBorder.texture:SetTexture('Interface/AchievementFrame/UI-Achievement-Progressive-IconBorder')
        SQA.frames['options' .. level .. 'Toggle'].checkBorder.texture:SetTexCoord(0, 0.65625, 0, 0.65625)
        SQA.frames['options' .. level .. 'Toggle'].checkBorder:SetAlpha(0.8)
        
        SQA.frames['options' .. level .. 'Toggle'].check = CreateFrame('Frame', key .. 'EnabledCheck', SQA.frames['options' .. level .. 'Toggle'])
        SQA.frames['options' .. level .. 'Toggle'].check:SetFrameStrata('MEDIUM')
        SQA.frames['options' .. level .. 'Toggle'].check:SetSize(18, 18)
        SQA.frames['options' .. level .. 'Toggle'].check:SetPoint('TOPLEFT', SQA.frames['options' .. level .. 'Toggle'], 'TOPLEFT', -2, -2)
        SQA.frames['options' .. level .. 'Toggle'].check.texture = SQA.frames['options' .. level .. 'Toggle'].check:CreateTexture()
        SQA.frames['options' .. level .. 'Toggle'].check.texture:SetAllPoints()
        SQA.frames['options' .. level .. 'Toggle'].check.texture:SetTexture('Interface/AchievementFrame/UI-Achievement-Criteria-Check')
        SQA.frames['options' .. level .. 'Toggle'].check.texture:SetTexCoord(0, 0.65625, 0, 1)
        
        if(SQA.options[level].enabled ~= true) then
            SQA.frames['options' .. level .. 'Toggle'].check:Hide()
        end
        
        SQA.frames['options' .. level .. 'Toggle']:SetScript('OnEnter', function(self)
            self.checkBorder:SetAlpha(1)
        end)
        
        SQA.frames['options' .. level .. 'Toggle']:SetScript('OnLeave', function(self)
            self.checkBorder:SetAlpha(0.8)
        end)
        
        SQA.frames['options' .. level .. 'Toggle']:SetScript('OnMouseDown', function(self, button)
            if(button == 'LeftButton') then
                if(SQA.options[self.level].enabled == true) then
                    self.check:Hide()
                    SQA.options[self.level].enabled = false
                else
                    self.check:Show()
                    SQA.options[self.level].enabled = true
                end
            end
        end)
        
        ----
        
        SQA.frames['options' .. level .. 'BidHeader'] = CreateFrame('Frame', key .. 'BidHeader', SQA.frames.optionsMaster)
        SQA.frames['options' .. level .. 'BidHeader']:SetPoint('TOPLEFT', SQA.frames['options' .. level .. 'Toggle'], 'BOTTOMLEFT', 0, -2)
        SQA.frames['options' .. level .. 'BidHeader']:SetFrameStrata('MEDIUM')
        SQA.frames['options' .. level .. 'BidHeader']:SetWidth(176)
        SQA.frames['options' .. level .. 'BidHeader']:SetHeight(10)
        SQA.frames['options' .. level .. 'BidHeader'].text = SQA.frames['options' .. level .. 'BidHeader']:CreateFontString(nil, 'ARTWORK')
        SQA.frames['options' .. level .. 'BidHeader'].text:SetFont('Fonts\\FRIZQT__.TTF', 10)
        SQA.frames['options' .. level .. 'BidHeader'].text:SetHeight(10)
        SQA.frames['options' .. level .. 'BidHeader'].text:SetAllPoints()
        SQA.frames['options' .. level .. 'BidHeader'].text:SetJustifyH('LEFT')
        SQA.frames['options' .. level .. 'BidHeader'].text:SetText('Starting Price')
        
        SQA.frames['options' .. level .. 'Bid'] = CreateFrame('EditBox', key .. 'Bid', SQA.frames.optionsMaster, 'MoneyInputFrameTemplate')
        SQA.frames['options' .. level .. 'Bid']:SetPoint('TOPLEFT', SQA.frames['options' .. level .. 'BidHeader'], 'BOTTOMLEFT', 5, -2)
        SQA.frames['options' .. level .. 'Bid']:SetFrameStrata('MEDIUM')
        SQA.frames['options' .. level .. 'Bid']:SetMaxLetters(2)
        SQA.frames['options' .. level .. 'Bid']:SetHeight(20)
        SQA.frames['options' .. level .. 'Bid']:SetMovable(false)
        SQA.frames['options' .. level .. 'Bid']:SetAutoFocus(false)
        SQA.frames['options' .. level .. 'Bid'].gold:SetMaxLetters(6)
        SQA.frames['options' .. level .. 'Bid'].silver:SetMaxLetters(2)
        SQA.frames['options' .. level .. 'Bid'].copper:SetMaxLetters(2)
        
        SQA.frames['options' .. level .. 'Bid'].gold:SetNumber(SQA.options[level].bidG)
        SQA.frames['options' .. level .. 'Bid'].silver:SetNumber(SQA.options[level].bidS)
        SQA.frames['options' .. level .. 'Bid'].copper:SetNumber(SQA.options[level].bidC)
        
        SQA.frames['options' .. level .. 'Buy'] = CreateFrame('EditBox', key .. 'Buy', SQA.frames.optionsMaster, 'MoneyInputFrameTemplate')
        SQA.frames['options' .. level .. 'Buy']:SetPoint('TOPLEFT', SQA.frames['options' .. level .. 'Bid'], 'TOPRIGHT', 10, 0)
        SQA.frames['options' .. level .. 'Buy']:SetFrameStrata('MEDIUM')
        SQA.frames['options' .. level .. 'Buy']:SetMaxLetters(2)
        SQA.frames['options' .. level .. 'Buy']:SetHeight(20)
        SQA.frames['options' .. level .. 'Buy']:SetMovable(false)
        SQA.frames['options' .. level .. 'Buy']:SetAutoFocus(false)
        SQA.frames['options' .. level .. 'Buy'].gold:SetMaxLetters(6)
        SQA.frames['options' .. level .. 'Buy'].silver:SetMaxLetters(2)
        SQA.frames['options' .. level .. 'Buy'].copper:SetMaxLetters(2)
        
        SQA.frames['options' .. level .. 'Buy'].gold:SetNumber(SQA.options[level].buyG)
        SQA.frames['options' .. level .. 'Buy'].silver:SetNumber(SQA.options[level].buyS)
        SQA.frames['options' .. level .. 'Buy'].copper:SetNumber(SQA.options[level].buyC)
        
        SQA.frames['options' .. level .. 'BuyHeader'] = CreateFrame('Frame', key .. 'BuyHeader', SQA.frames.optionsMaster)
        SQA.frames['options' .. level .. 'BuyHeader']:SetPoint('BOTTOMLEFT', SQA.frames['options' .. level .. 'Buy'], 'TOPLEFT', -5, 2)
        SQA.frames['options' .. level .. 'BuyHeader']:SetFrameStrata('MEDIUM')
        SQA.frames['options' .. level .. 'BuyHeader']:SetWidth(176)
        SQA.frames['options' .. level .. 'BuyHeader']:SetHeight(10)
        SQA.frames['options' .. level .. 'BuyHeader'].text = SQA.frames['options' .. level .. 'BuyHeader']:CreateFontString(nil, 'ARTWORK')
        SQA.frames['options' .. level .. 'BuyHeader'].text:SetFont('Fonts\\FRIZQT__.TTF', 10)
        SQA.frames['options' .. level .. 'BuyHeader'].text:SetHeight(10)
        SQA.frames['options' .. level .. 'BuyHeader'].text:SetAllPoints()
        SQA.frames['options' .. level .. 'BuyHeader'].text:SetJustifyH('LEFT')
        SQA.frames['options' .. level .. 'BuyHeader'].text:SetText('Buyout Price')
        
        anchorPoint = SQA.frames['options' .. level .. 'Bid']
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
        SQA.options[level].bidG = SQA.frames['options' .. level .. 'Bid'].gold:GetNumber()
        SQA.options[level].bidS = SQA.frames['options' .. level .. 'Bid'].silver:GetNumber()
        SQA.options[level].bidC = SQA.frames['options' .. level .. 'Bid'].copper:GetNumber()
        SQA.options[level].buyG = SQA.frames['options' .. level .. 'Buy'].gold:GetNumber()
        SQA.options[level].buyS = SQA.frames['options' .. level .. 'Buy'].silver:GetNumber()
        SQA.options[level].buyC = SQA.frames['options' .. level .. 'Buy'].copper:GetNumber()
    end
    
    _G['SQA_OPTIONS'] = SQA.options
end

local function getTooltipLines(tooltip)
    local lines = {}
    local tooltipLines = {tooltip:GetRegions()}
    
    for _, line in ipairs(tooltipLines) do
        if(line:IsObjectType('FontString')) then
            table.insert(lines, line:GetText())
        end
    end
    
    return lines
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
        'Titanforged',
        'Warforged',
        'Lightforged'
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
