import uuid

from django.db import models
from backend.base_classes import CreatedUpdated


class Item(CreatedUpdated):

    id = models.UUIDField(
        primary_key=True,
        default=uuid.uuid4,
        editable=False
    )

    name = models.CharField(
        max_length=30
    )

    # Each item has its own price
    price = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        null=True,
    )

    def __str__(self):
        return self.name

    class Meta:
        ordering = ['name']
