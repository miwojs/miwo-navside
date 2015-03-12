Header = require './Header'
Item = require './Item'
ItemGroup = require './ItemGroup'


class Navigation extends Miwo.panel.Pane

	componentCls: 'navside'
	active: null
	role: 'navigation'
	scrollable: true


	afterInit: ->
		super
		@mon(window, 'hashchange', 'onWindowHashChange')
		return


	addItem: (name, config) ->
		return @add(name, new Item(config))


	addItemGroup: (name, config) ->
		return @add(name, new ItemGroup(config))


	addHeader: (name, config) ->
		return @add(name, new Header(config))


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
		miwo.redirect(item.target)  if item.target && !@preventHashChange
		return


	onItemActive: (item) ->
		if @active is item then return
		@active.setActive(false, true) if @active
		@active = item
		@emit('active', this, item)
		return


	onItemGroupOpen: (itemGroup) ->
		@emit('open', this, itemGroup)
		return


	onItemGroupClose: (itemGroup) ->
		@emit('close', this, itemGroup)
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
		for component in @findAll('navsideitem')
			if target.indexOf(component.target) >= 0
				@preventHashChange = true
				component.setActive(true)
				@preventHashChange = false
				break
		return


module.exports = Navigation