from django.db import models
from user_profile.models import User

class Note(models.Model):
	user = models.ForeignKey(User)
	text = models.CharField(max_length=160)
	created_date = models.DateTimeField(auto_now_add=True)