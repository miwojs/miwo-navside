class Header extends Miwo.Component

	xtype: 'navsideheader'
	baseCls: 'navside-header'
	text: ''

	doRender: ->
		@el.set('html', '<span>'+@text+'</span>')
		return


module.exports = Header