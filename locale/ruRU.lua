local L = KuiPVPConfig:Locale('ruRU')
if not L then return end

L["titles"] = {
    ["iconFaction"] = "Показать иконки всех фракций",
    ["iconCombat"] = "Показать PVP иконки",
    ["iconSize"] = "Изменить размер иконки",
    ["iconOwnFaction"] = "Скрыть иконки своей фракции",
}
L["tooltips"] = {
    iconFaction = 'Показать иконки всех фракций',
    iconCombat = 'Показывать PVP иконки (перекрестие мечей)',
    iconSize = 'Изменить размер иконок',
    iconOwnFaction = 'Скрыть иконки своей фракции (показывает иконки противоположной фракции)',
    Debugger = 'вывести отладочную информацию в чат',
}