from hello_world.app import Cow


def test_moo():
    app = Cow("John")
    app.say_hello()


def test_greeting_includes_name():
    app = Cow("John")
    result = app.say_hello()
    assert "John" in result
