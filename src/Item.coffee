class Item extends Miwo.Component

	xtype: 'navsideitem'
	componentCls: 'navside-item'
	icon: ''
	text: ''
	active: false
	role: 'presentation'


	doRender: ->
		@el.set 'html', '<a href="#" role="menuitem"><i class="navside-icon '+@icon+'"></i><span>'+@text+'</span></a>'
		return


	afterRender: ->
		super
		@el.on 'click', (event)=>
			event.stop()
			@emit('click', this)
			return
		return


	setActive: (active, silent) ->
		if @active is active then return
		@active = active
		@el.toggleClass('active', active)
		@emit('active', this)  if !silent
		return



module.exports = Item