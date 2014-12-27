Item = require './Item'
ItemGroup = require './ItemGroup'


class Navigation extends Miwo.Container

	componentCls: 'navside'
	active: null
	role: 'navigation'


	afterInit: ->
		super
		@mon(window, 'hashchange', 'onWindowHashChange')
		return


	addItem: (name, text) ->
		return @add name, new Item
			text: text


	addItemGroup: (name, text) ->
		return @add name, new ItemGroup
			text: text


	addedComponentDeep: (component) ->
		super(component)
		if component instanceof Item
			@mon(component, 'active', 'onItemActive')
			@mon(component, 'click', 'onItemClick')
		if component instanceof ItemGroup
			@mon(component, 'open', 'onItemGroupOpen')
			@mon(component, 'close', 'onItemGroupClose')
		return


	removedComponentDeep: (component) ->
		super(component)
		if component instanceof Item
			@mun(component, 'active', 'onItemActive')
			@mun(component, 'click', 'onItemClick')
		if component instanceof ItemGroup
			@mun(component, 'open', 'onItemGroupOpen')
			@mun(component, 'close', 'onItemGroupClose')
		return


	onItemClick: (item) ->
		item.setActive(true)  if @active isnt item
		return


	onItemActive: (item) ->
		if @active is item then return
		@active.setActive(false, true) if @active
		@active = item
		@emit('active', this, item)
		document.location.hash = item.target  if item.target && !@preventHashChange
		return


	onItemGroupOpen: (itemgroup) ->
		@emit('open', this, itemgroup)
		return


	onItemGroupClose: (itemgroup) ->
		@emit('close', this, itemgroup)
		return


	onWindowHashChange: ->
		@setActivateByTarget(document.location.hash)
		return


	afterRender: ->
		super
		@setActivateByTarget(document.location.hash)
		return


	setActivateByTarget: (target) ->
		if !target then return
		for component in @findComponents(true, {xtype: 'navsideitem'})
			if target.indexOf(component.target) >= 0
				@preventHashChange = true
				component.setActive(true)
				@preventHashChange = false
				break
		return


module.exports = Navigation