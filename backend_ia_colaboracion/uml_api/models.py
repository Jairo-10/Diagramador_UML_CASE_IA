from django.db import models

# Modelo para persistir el diagrama UML asociado a una sala UUID
class BackupUML(models.Model):
    room_id = models.UUIDField(unique=True)
    data = models.JSONField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return str(self.room_id)
