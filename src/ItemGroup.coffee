Item = require './Item'


class ItemGroup extends Miwo.Container

	xtype: 'navsidegroup'
	componentCls: 'navside-group'
	icon: ''
	text: ''
	opened: true
	role: 'presentation'


	addItem: (name, text) ->
		return @add name, new Item
			text: text


	beforeRender: ->
		super
		@el.set 'html',
		'<div class="navside-item"><a role="menuitem" miwo-events="click:onItemClick" href="#"><i class="navside-icon '+@icon+'"></i><span>'+@text+'</span><i miwo-reference="switchiconEl" class="switchicon glyphicon"></i></a></div>'+
		'<div class="navside-items" role="menu" miwo-reference="contentEl"></div>'
		return


	afterRender: ->
		super
		@setOpened(@opened, true)
		return


	onItemClick: (event) ->
		event.stop()
		@toggle()
		return


	toggle: ->
		@setOpened(!@opened)
		return


	setOpened: (opened, silent) ->
		@opened = opened
		@contentEl.setVisible(opened)
		@switchiconEl.toggleClass('glyphicon-chevron-down', !opened)
		@switchiconEl.toggleClass('glyphicon-chevron-up', opened)
		(if opened then @emit('open', this) else @emit('close', this)) if !silent
		return



module.exports = ItemGroup