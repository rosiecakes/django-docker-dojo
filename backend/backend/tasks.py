from celery.task import task
from items.models import Item


@task()
def update_example(name="update_example"):

    items = Item.objects.all()

    # For our example, we just increment the price by 2 every run
    for item in items:
        item.price += 2
        item.save()
        print(item.price)
