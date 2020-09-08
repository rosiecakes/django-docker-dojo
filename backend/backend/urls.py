"""hello URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from rest_framework import routers
from items.views import ItemViewSet

# Django admin header
admin.site.site_header = "Docker Django React Starter"

# Project-wide router
router = routers.DefaultRouter()

# We register all ViewSets here
router.register(
    r'api/items', ItemViewSet
)

urlpatterns = [
    path('admin/', admin.site.urls),
]

#  We enforce that urlpatterns includes all of the registered URLs
urlpatterns += router.urls
