from celery.task import task
from items.models import Item


@task()
def update_example(name="update_example"):
    #  Get all Items from the db and count them
    items = Item.objects.all()
    item_count = items.count()
    # For our example, we just increment the price by 2 every run
    for item in items:
        item.price += 2
        item.save()
    # Print to terminal for demonstration purposes
    print(f'Price update for {item_count} Items, ran and completed.')
