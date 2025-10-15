rule = {
    matches = {
        { {"device.name","equals","bluez_card.14_DD_02_05_C2_03"} }
    },
    apply_properties = {
        ["device.profile"] ="a2dp-sink-ldac"
    }
}
table.insert(alsa_monitor.rules, rule)
