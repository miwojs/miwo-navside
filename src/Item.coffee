class Item extends Miwo.Component

	xtype: 'navsideitem'
	componentCls: 'navside-item'
	icon: ''
	text: ''
	active: false
	role: 'presentation'
	badge: null


	beforeRender: ->
		super
		@el.on 'click', (event)=>
			event.stop()
			@emit('click', this)
			return
		return


	doRender: ->
		inner = '<i class="'+@icon+'"></i><span>'+@text+'</span>'
		inner += '<span class="badge">'+@badge+'</span>' if @badge
		@el.set('html', '<a href="#" role="menuitem">'+inner+'</a>')
		return


	setActive: (active, silent) ->
		if @active is active then return
		@active = active
		@el.toggleClass('active', active)
		@emit('active', this)  if !silent
		return


	setBadge: (@badge) ->
		@redraw()
		return


module.exports = Item