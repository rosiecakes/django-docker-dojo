from django.db import models


class CreatedUpdated(models.Model):
    """Abstract base class inherited by main classes in the system."""

    # When object is created
    created = models.DateTimeField(
        auto_now_add=True,
        null=True,
    )

    # When object is updated in the future, after being created
    updated = models.DateTimeField(
        auto_now=True,
        null=True,
    )

    class Meta:
        abstract = True
