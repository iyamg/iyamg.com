---
title: Functional Programming Tips in Python
summary: These features will allow you to create code that flows when writing and reads effortlessly
date: 2024-10-20
tags:
  - python
slug: 03-functional-python
---
Despite not being a pure functional language, a lot of praise that python receives are for features that stem from functional paradigms. Many are second nature to python programmers, but over the years I have seen people miss out on some important features. I gathered a few, along with examples, to give a brief demonstration of the convenience they can bring.

## Replace `if/else`  with `or` 
With values that might be `None`, you can use `or` instead of `if/else` to provide a default. I had used this for years with Javascript, without knowing it was also possible in Python.

```python
def get_greeting_prefix(user_title: str | None):
	if user_title:
		return user_title
	return ""
```

Above snippet can shortened to this: 
```python
def get_greeting_prefix(user_title: str | None):
	return user_title or ""
```


## Pattern Matching and Unpacking
The overdue arrival of `match` to python means that so many `switch` style statements are expressed instead with convoluted `if/else` blocks. Using `match` is not even from the functional paradigm, but combining it with unpacking opens up new possibilities for writing more concise code.

Let's start by looking at a primitive example of unpacking. Some libraries have popularised use of `[a, b] = some_fun()`, but unpacking in python is much powerful than that. 

```python
[first, *mid, last] = [1, 2, 3, 4, 5]
# first -> 1, mid -> [2, 3, 4], last -> 5
```

### Matching Lists

Just look at the boost in readability when we are able to name and extract relevant values effortlessly:

``` python
def sum(numbers: [int]):
	if len(numbers) == 0:
		return 0
	else:
		return numbers[0] + sum(numbers[1:])
```


```python
def sum(numbers: [int]):
	match numbers:
		case []:
			return 0
		case [first, *rest]:
			return first + sum(rest)
```


###  Matching Dictionaries
Smooth, right? We can go even further with dictionaries. This example is not necessarily better than its `if/else` counterpart, but I will use it for the purpose of demonstrating the functionality.

```python
sample_country = {"economic_zone": "EEA", "country_code": "AT"}

def determine_tourist_visa_requirement(country: dict[str, str]):
	match country:
		case {"economic_zone": "EEA"}:
			return "no_visa"
		case {"country_code": code} if code in tourist_visa_free_countries:
			return "non_tourist_visa_only"
		case default:
			return "visa_required"		
```


### Matching `Dataclasses`
Let’s write a function that does a primitive calculation of an estimated number of days for shipment
```python
@dataclass
class Address:
	street: str
	zip_code: str
	country_code: str
```

```python
def calculate_shipping_estimate(address: Address) -> int:
	match address:
		case Address(zip_code=zc) if close_to_warehouse(zc):
			return 1
		case Address(country_code=cc) if cc in express_shipping_countries:
			return 2
		case default:
			return provider_estimate(city.coordinates)
```

## Comprehensions
List comprehensions get their deserved spotlight, but I’ve seen cases where dictionary comprehension would’ve cut multiple lines. You can look at examples [on this page on python.org](https://peps.python.org/pep-0274/#examples)
