from rest_framework import serializers as s
from .models import Item


class ItemSerializer(s.ModelSerializer):

    #  We make things read-only, here
    def __init__(self, *args, **kwargs):
        super(ItemSerializer, self).__init__(*args, **kwargs)
        setattr(self.Meta, 'read_only_fields', [*self.fields])

    class Meta:
        model = Item
        fields = [
            'id',
            'pk',
            'name',
            'price',
        ]
