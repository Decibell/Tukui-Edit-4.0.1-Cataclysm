-- move durability frame.

hooksecurefunc(DurabilityFrame,"SetPoint",function(self,_,parent)
    if (parent == "MinimapCluster") or (parent == _G["MinimapCluster"]) then
        self:ClearAllPoints()
		self:SetPoint("TOP", TukuiMinimap, "BOTTOM", 0, -20);
    end
end)