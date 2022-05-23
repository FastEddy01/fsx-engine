Core = {}

Core.table = Table -- contains extended table library
Core.string = String -- contains extended string library

Core.event = {
	client = Core.string.hash(Core.string.random(10)),
	server = Core.string.hash(Core.string.random(10))
}