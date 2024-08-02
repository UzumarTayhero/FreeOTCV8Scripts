local methods = {
      session = "",
    _methods = {
        {"item", modules._G.Item}, {"tile", modules._G.Tile},
        {"thing", modules._G.Thing}, {"player", modules._G.Player},
        {"creature", modules._G.Creature},
     --g_libs below(abaixo)
        {"g_map", g_map}, {"g_game", g_game},
        {"g_ui", g_ui}, {"g_mouse", g_mouse},
        {"g_window", g_window}, {"g_resources", g_resources},
        
    },
};
methods.ui = setupUI([[
MainWindow
  size: 300 260
  !text: tr("UzumarTayhero")
  @onSetup: self:hide()
  TextList
    id:list
    anchors.top:parent.top
    anchors.left:parent.left
    anchors.right: parent.right
    margin-right: 15
    layout: verticalBox
    size: 100 120
    vertical-scrollbar:scroll

  VerticalScrollBar
    id:scroll
    anchors.left: prev.right
    anchors.top:prev.top
    anchors.bottom:prev.bottom
    step: 10

  Button
    id: back
    anchors.bottom:parent.bottom
    margin-bottom: 20
    anchors.left:parent.left
    text: back
    width: 130
    height: 30

  Button
    id: next
    anchors.bottom:parent.bottom
    margin-bottom: 20
    height: 30
    anchors.right:parent.right
    anchors.left:back.right
    text: next

  Button
    id:close
    text:close
    anchors.bottom:parent.bottom
    anchors.left: parent.left
    anchors.right:parent.right
    @onClick: self:getParent():hide()

  TextEdit
    id:text
    anchors.bottom:back.top
    margin-bottom: 0
    anchors.left:parent.left
    anchors.right:parent.right
    color: white

]], g_ui.getRootWidget())

methods.entry = [[
Label
  text-align: left
  background-color: alpha
  focusable:true
  $focus:
    background-color:#00000055
]]

function methods.transformToIndex(table)
    if not table then return nil end
    local t = {};
    for key, value in pairs(table) do
        t[#t+1] = key;
    end
    return t
end


methods.refreshList = function(order)
    local list = methods.ui.list;
    list:destroyChildren();
    local path = methods.transformToIndex(order) or methods._methods;
    for index, entry in ipairs(path) do
        local label = g_ui.loadUIFromString(methods.entry, list);
        if type(entry) == "string" and entry:find("on") then label:destroy(); end
        label.onDoubleClick = function(self)
            if self:getText() == entry[1] then
                methods.session = entry[1];
                methods.refreshList(entry[2]);
            else
                g_window.setClipboardText(label:getText());
            end
         end
        if methods.session:len() > 0 then
            if methods.session:find("_") then
                local coloredText = {methods.session, "white", ".", "white", entry, "orange", "()", "white"};
                label:setColoredText(coloredText);
                methods.focusWidget(label);
            else
                local coloredText = {methods.session, "white", ":", "white", entry, "orange", "()", "white"};
                label:setColoredText(coloredText);
                methods.focusWidget(label);
            end
        else
            label:setText(entry[1])
        end
    end
end
methods.refreshList()

methods.ui.back.onClick = function(self)
    methods.session = "";
    methods.ui.text:clearText();
    methods.refreshList()
end
methods.ui.next.onClick = function(self)
    local list = methods.ui.list;
    local focusChild = list:getFocusedChild();
    focusChild:onDoubleClick();
end

methods.focusWidget = function(child)
    child.onFocusChange = function(self, focus, b)
        if focus then
            methods.ui.text:setText(self:getText());
        end
    end
end

UI.Button("Show methods", function()
    local ui = methods.ui;
    local visible = ui:isVisible();
    if not visible then
        ui:show();
        ui:raise();
        ui:focus();
    else
        ui:hide();
    end
end)
