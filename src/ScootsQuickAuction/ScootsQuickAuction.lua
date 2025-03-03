SQA = {}
SQA.loaded = false
SQA.active = false

SQA.frame = CreateFrame('Frame', 'ScootsQuickAuctionMasterFrame', _G['AuctionFrameAuctions'])

function SQA.openAuctionHouse()
	if(SQA.loaded == false) then
		SQA.frame:SetSize(178, 117)
		SQA.frame:SetPoint('TOPLEFT', _G['AuctionFrameAuctions'], 'TOPRIGHT', 70, -12)
		SQA.frame:SetFrameStrata('MEDIUM')
	
		SQA.frame.texture = SQA.frame:CreateTexture()
		SQA.frame.texture:SetAllPoints()
		SQA.frame.texture:SetTexture(0, 0, 0, 0.5)
		
		SQA.borderFrames = {}
		SQA.borderFrames.T = CreateFrame('Frame', 'ScootsQuickAuctionBorderTop', SQA.frame)
		SQA.borderFrames.R = CreateFrame('Frame', 'ScootsQuickAuctionBorderRight', SQA.frame)
		SQA.borderFrames.B = CreateFrame('Frame', 'ScootsQuickAuctionBorderBottom', SQA.frame)
		SQA.borderFrames.L = CreateFrame('Frame', 'ScootsQuickAuctionBorderLeft', SQA.frame)
		
		for key, borderFrame in pairs(SQA.borderFrames) do
			borderFrame.texture = borderFrame:CreateTexture()
			borderFrame.texture:SetAllPoints()
			borderFrame.texture:SetTexture(1, 1, 1, 0.5)
			borderFrame:SetWidth(1)
			borderFrame:SetHeight(1)
			borderFrame:SetFrameStrata('MEDIUM')
		end
	
		SQA.borderFrames.T:SetPoint('BOTTOM', SQA.frame, 'TOP', 0, 0)
		SQA.borderFrames.T:SetWidth(SQA.frame:GetWidth() + 2)
		SQA.borderFrames.B:SetPoint('TOP', SQA.frame, 'BOTTOM', 0, 0)
		SQA.borderFrames.B:SetWidth(SQA.frame:GetWidth() + 2)
		
		SQA.borderFrames.R:SetPoint('LEFT', SQA.frame, 'RIGHT', 0, 0)
		SQA.borderFrames.R:SetHeight(SQA.frame:GetHeight())
		SQA.borderFrames.L:SetPoint('RIGHT', SQA.frame, 'LEFT', 0, 0)
		SQA.borderFrames.L:SetHeight(SQA.frame:GetHeight())
		
		SQA.textFrames = {}
		SQA.textFrames.header = CreateFrame('Frame', 'ScootsQuickAuctionTextHeader', SQA.frame)
		SQA.textFrames.bid = CreateFrame('Frame', 'ScootsQuickAuctionTextBid', SQA.frame)
		SQA.textFrames.buy = CreateFrame('Frame', 'ScootsQuickAuctionTextBuy', SQA.frame)
		
		for key, textFrame in pairs(SQA.textFrames) do
			textFrame:SetFrameStrata('HIGH')
			textFrame:SetWidth(SQA.frame:GetWidth() - 10)
			textFrame:SetHeight(10)
			textFrame.text = textFrame:CreateFontString(nil, 'ARTWORK')
			textFrame.text:SetFont('Fonts\\FRIZQT__.TTF', 10)
			textFrame.text:SetHeight(10)
			textFrame.text:SetAllPoints()
			textFrame.text:SetJustifyH('LEFT')
		end
		
		SQA.textFrames.header.text:SetText('ScootsQuickAuction')
		SQA.textFrames.header.text:SetFont('Fonts\\FRIZQT__.TTF', 12)
		SQA.textFrames.header:SetHeight(12)
		SQA.textFrames.header:SetPoint('TOPLEFT', SQA.frame, 'TOPLEFT', 5, -5)
		
		SQA.textFrames.bid.text:SetText('Bid')
		SQA.textFrames.bid:SetPoint('TOPLEFT', SQA.textFrames.header, 'BOTTOMLEFT', 0, -5)
		
		SQA.inputs = {}
		SQA.inputs.bid = CreateFrame('EditBox', 'ScootsQuickAuctionInputBid', SQA.frame, 'MoneyInputFrameTemplate')
		SQA.inputs.buy = CreateFrame('EditBox', 'ScootsQuickAuctionInputBuy', SQA.frame, 'MoneyInputFrameTemplate')
		
		for key, input in pairs(SQA.inputs) do
			input:SetFrameStrata('HIGH')
			input:SetMaxLetters(2)
			input:SetHeight(20)
			input:SetMovable(false)
			input:SetAutoFocus(false)
			input.gold:SetMaxLetters(6)
			input.silver:SetMaxLetters(2)
			input.copper:SetMaxLetters(2)
		end
		
		SQA.inputs.bid:SetPoint('TOPLEFT', SQA.textFrames.bid, 'BOTTOMLEFT', 5, 0)
		
		SQA.inputs.bid.gold:SetNumber(SQA.options.bidGold)
		SQA.inputs.bid.silver:SetNumber(SQA.options.bidSilver)
		SQA.inputs.bid.copper:SetNumber(SQA.options.bidCopper)
		SQA.inputs.buy.gold:SetNumber(SQA.options.buyGold)
		SQA.inputs.buy.silver:SetNumber(SQA.options.buySilver)
		SQA.inputs.buy.copper:SetNumber(SQA.options.buyCopper)
		
		SQA.textFrames.buy.text:SetText('Buyout')
		SQA.textFrames.buy:SetPoint('TOPLEFT', SQA.inputs.bid, 'BOTTOMLEFT', -5, -5)
		
		SQA.inputs.buy:SetPoint('TOPLEFT', SQA.textFrames.buy, 'BOTTOMLEFT', 5, 0)
		
		SQA.button = CreateFrame('Button', 'ScootsQuickAuctionButton', SQA.frame, 'UIPanelButtonTemplate')
		SQA.button:SetSize(100, 20)
		SQA.button:SetText('Quick List: off')
		SQA.button:SetPoint('TOPLEFT', SQA.inputs.buy, 'BOTTOMLEFT', -6, -5)
		SQA.button:SetFrameStrata('HIGH')
		SQA.button:SetScript('OnClick', SQA.clickButton)
		
		_G['AuctionsItemButton']:SetScript('OnEvent', SQA.doAuctionEvent)
		
		SQA.loaded = true
	end
	
	SQA.frame:Show()
end

function SQA.closeAuctionHouse()
	SQA.setOptions()
	SQA.frame:Hide()
end

function SQA.clickButton()
	if(SQA.active == true) then
		SQA.button:SetText('Quick List: off')
		SQA.active = false
	else
		SQA.button:SetText('Quick List: on')
		SQA.active = true
	end
end

function SQA.setOptions()
	SQA.options.bidGold = SQA.inputs.bid.gold:GetNumber()
	SQA.options.bidSilver = SQA.inputs.bid.silver:GetNumber()
	SQA.options.bidCopper = SQA.inputs.bid.copper:GetNumber()
	SQA.options.buyGold = SQA.inputs.buy.gold:GetNumber()
	SQA.options.buySilver = SQA.inputs.buy.silver:GetNumber()
	SQA.options.buyCopper = SQA.inputs.buy.copper:GetNumber()
	_G['SQA_OPTIONS'] = SQA.options
end

function SQA.doAuctionEvent(self, event, ...)
	AuctionSellItemButton_OnEvent(self, event)
	if(SQA.active == true) then
		if(event == 'NEW_AUCTION_UPDATE') then
			if(not GetAuctionSellItemInfo()) then
				return
			end
			
			SQA.setOptions()
			
			_G['StartPriceGold']:SetNumber(SQA.options.bidGold)
			_G['StartPriceSilver']:SetNumber(SQA.options.bidSilver)
			_G['StartPriceCopper']:SetNumber(SQA.options.bidCopper)
			
			_G['BuyoutPriceGold']:SetNumber(SQA.options.buyGold)
			_G['BuyoutPriceSilver']:SetNumber(SQA.options.buySilver)
			_G['BuyoutPriceCopper']:SetNumber(SQA.options.buyCopper)
			
			_G['AuctionsCreateAuctionButton']:Click()
		end
	end
end

function SQA.onLoad()
	SQA.options = {
		['bidGold'] = 75,
		['bidSilver'] = 0,
		['bidCopper'] = 0,
		['buyGold'] = 100,
		['buySilver'] = 0,
		['buyCopper'] = 0
	}
	
	if(_G['SQA_OPTIONS'] ~= nil) then
		if(_G['SQA_OPTIONS'].bidGold ~= nil) then
			SQA.options.bidGold = _G['SQA_OPTIONS'].bidGold
		end
		if(_G['SQA_OPTIONS'].bidSilver ~= nil) then
			SQA.options.bidSilver = _G['SQA_OPTIONS'].bidSilver
		end
		if(_G['SQA_OPTIONS'].bidCopper ~= nil) then
			SQA.options.bidCopper = _G['SQA_OPTIONS'].bidCopper
		end
		if(_G['SQA_OPTIONS'].buyGold ~= nil) then
			SQA.options.buyGold = _G['SQA_OPTIONS'].buyGold
		end
		if(_G['SQA_OPTIONS'].buySilver ~= nil) then
			SQA.options.buySilver = _G['SQA_OPTIONS'].buySilver
		end
		if(_G['SQA_OPTIONS'].buyCopper ~= nil) then
			SQA.options.buyCopper = _G['SQA_OPTIONS'].buyCopper
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

SQA.frame:SetScript('OnEvent', SQA.eventHandler)
SQA.frame:RegisterEvent('AUCTION_HOUSE_SHOW')
SQA.frame:RegisterEvent('AUCTION_HOUSE_CLOSED')
SQA.frame:RegisterEvent('ADDON_LOADED')