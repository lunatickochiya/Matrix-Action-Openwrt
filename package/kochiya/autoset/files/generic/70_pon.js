// SPDX-License-Identifier: Apache-2.0
//
// PON 光模块状态：温度 / 收发光功率，显示在「状态 → 概览」页。
// 数据来源：ponctl --device <dev> status --json
//           （airoha-ponctl，status.rs 的 convert_optics 已换算成显示单位）
//
// 字段名与单位换算对照 airoha-ponctl/src/src/status.rs：
//   temperature_8472 / 256   -> temperature_celsius  (°C)
//   voltage_8472     * 1e-4  -> voltage_volts        (V)
//   tx_bias_8472     * 0.002 -> tx_bias_ma           (mA)
//   tx_power_8472 -> 10*log10(v)-40 -> tx_power_dbm  (dBm)
//   rx_power_8472 -> 10*log10(v)-40 -> rx_power_dbm  (dBm)

'use strict';
'require baseclass';
'require fs';
'require uci';

function readFrontend(device) {
	return L.resolveDefault(fs.exec_direct('/usr/sbin/ponctl',
		[ '--device', device, 'status', '--json' ]), null).then(function(output) {
		if (output == null)
			return { error: _('读取失败（设备不可用）') };

		try {
			var snapshot = JSON.parse(output);
			if (snapshot.schema_version !== 1)
				throw new Error('schema');
			return snapshot.frontend || {};
		} catch (e) {
			return { error: _('解析失败') };
		}
	});
}

function metric(frontend, field, unit, digits) {
	if (frontend.error)
		return frontend.error;
	if (!Object.prototype.hasOwnProperty.call(frontend, field))
		return _('不支持');
	return Number(frontend[field]).toFixed(digits == null ? 2 : digits) + ' ' + unit;
}

function renderBox(item) {
	var frontend = item.frontend || {};

	return E('div', { 'class': 'ifacebox' }, [
		E('div', { 'class': 'ifacebox-head center active' },
			E('strong', item.device)),
		E('div', { 'class': 'ifacebox-body left' },
			L.itemlist(E('span'), [
				_('收光功率'), metric(frontend, 'rx_power_dbm', 'dBm'),
				_('发光功率'), metric(frontend, 'tx_power_dbm', 'dBm'),
				_('光模块温度'), metric(frontend, 'temperature_celsius', '°C'),
				_('偏置电流'), metric(frontend, 'tx_bias_ma', 'mA'),
				_('供电电压'), metric(frontend, 'voltage_volts', 'V', 4)
			]))
	]);
}

return baseclass.extend({
	title: _('PON 光模块'),

	load: function() {
		return uci.load('pon').then(function() {
			var lines = uci.sections('pon', 'xpon').filter(function(section) {
				return section.device;
			});

			if (!lines.length)
				return Promise.reject();

			return Promise.all(lines.map(function(section) {
				return readFrontend(section.device).then(function(frontend) {
					return {
						device: section.device,
						section: section['.name'],
						frontend: frontend
					};
				});
			}));
		});
	},

	render: function(data) {
		if (!data || !data.length)
			return null;

		return E('div', { 'id': 'pon_optics_table', 'class': 'network-status-table' },
			data.map(renderBox));
	}
});
