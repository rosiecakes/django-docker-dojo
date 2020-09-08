from .models import Item
from .serializers import ItemSerializer

from rest_framework import viewsets
from rest_framework.permissions import AllowAny


class ItemViewSet(viewsets.ReadOnlyModelViewSet):
    """
    Handles Datasets - DatasetResource & DatasetTags belong to Datasets.
    """
    permission_classes = [AllowAny]
    serializer_class = ItemSerializer
    queryset = Item.objects.all()
    pagination_class = None
