# To improve:

- it'd be nice to have paggination for when we return many results
- Performance and UX can be improved with turbo frames or a javascript framework.
- UX can be improved by saving the submitted ingredients within the url (e.g: /recipes/search?ingredient[]=pomme&ingredient[]=chocolat). This way, we can easily share the url without loosing its content
- some parts of the UI aren't using i18n... I was too lazy :-S
- the text_search postgresql tokenisation isn't perfect right now, we could improve it by:
  - removing any accent (e.g: we can't search for "bechamel", we must surch for "béchamel" which is tedious)
  - we should create postgresql stop words for full text search (e.g: skip words like "cuillères")
  - we should filter digits as well (e.g: "400g")
- we could implement some caching to make it lighter for the DB

# Remarks

- I somehow overlook the fact that you wanted a React implementation. So I went for something simple
