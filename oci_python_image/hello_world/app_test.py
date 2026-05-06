from hello_world.app import Cow


def test_moo():
    app = Cow("John")
    app.say_hello()

# Deliberately failing test to demonstrate test failure
 def test_name2():
    app = Cow("John")
    assert app.name == "James"


def test_name():
    app = Cow("John")
    assert app.name == "John"


def test_name2():
    app = Cow("John")
    assert app.name == "John"


def test_name3():
    app = Cow("John")
    assert app.name == "John"