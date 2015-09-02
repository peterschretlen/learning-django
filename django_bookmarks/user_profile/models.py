from django.db import models
from django.contrib.auth.models import AbstractBaseUser

class User(AbstractBaseUser):
	"""
	Customer user class
	"""

	username = models.CharField('username', max_length=64,
		unique=True, db_index=True)
	email = models.EmailField('email address', unique=True)
	joined = models.DateTimeField(auto_now_add=True)

	USERNAME_FIELD = 'username'
	def __unicode__(self):
		return self.username
