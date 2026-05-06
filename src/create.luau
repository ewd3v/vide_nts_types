-- from https://github.com/centau/vide/blob/19eaeb424fe06168772f8e6d5aaaf3ab5e78a316/src/create.luau
-- as v4 doesn't include these changes yet which aim to fix typesolver issues

--[[
MIT License

Copyright (c) 2022 centau

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

type Instances = {
	AdGui: AdGui,
	BillboardGui: BillboardGui,
	Camera: Camera,
	CanvasGroup: CanvasGroup,
	Folder: Folder,
	Frame: Frame,
	ImageButton: ImageButton,
	ImageLabel: ImageLabel,
	Path2D: Path2D,
	ScreenGui: ScreenGui,
	ScrollingFrame: ScrollingFrame,
	SurfaceGui: SurfaceGui,
	TextBox: TextBox,
	TextButton: TextButton,
	TextLabel: TextLabel,
	UIAspectRatioConstraint: UIAspectRatioConstraint,
	UICorner: UICorner,
	UIDragDetector: UIDragDetector,
	UIFlexItem: UIFlexItem,
	UIGradient: UIGradient,
	UIGridLayout: UIGridLayout,
	UIListLayout: UIListLayout,
	UIPadding: UIPadding,
	UIPageLayout: UIPageLayout,
	UIScale: UIScale,
	UIShadow: UIShadow,
	UISizeConstraint: UISizeConstraint,
	UIStroke: UIStroke,
	UITableLayout: UITableLayout,
	UITextSizeConstraint: UITextSizeConstraint,
	VideoDisplay: VideoDisplay,
	VideoFrame: VideoFrame,
	ViewportFrame: ViewportFrame,
	WorldModel: WorldModel,
}

export type function Properties(instance: type?)
	local properties = types.newtable()

	while instance do
		for i, v in instance:properties() do
			local connector = v.read and v.read.tag == "table" and v.read:readproperty(types.singleton("Connect"))
			if connector then
				local params = connector:parameters().head
				if not params then
					continue
				end
				local listener = params[2]
				if not listener then
					continue
				end
				properties:setproperty(i, types.optional(listener))
			elseif v.write then
				properties:setproperty(
					i,
					types.optional(types.unionof(v.write, types.newfunction({}, { head = { v.write } })))
				)
			end
		end

		instance = instance:readparent()
	end

	properties:setindexer(types.number, types.any)

	return properties
end

type Create = <Name>(Name | keyof<Instances> | "") -> (Properties<index<Instances, Name>>) -> index<Instances, Name>

local create = require("../roblox_packages/vide").create
return create :: Create
