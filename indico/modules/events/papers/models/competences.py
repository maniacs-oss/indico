# This file is part of Indico.
# Copyright (C) 2002 - 2018 European Organization for Nuclear Research (CERN).
#
# Indico is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 3 of the
# License, or (at your option) any later version.
#
# Indico is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Indico; if not, see <http://www.gnu.org/licenses/>.

from __future__ import unicode_literals

from sqlalchemy import ARRAY

from indico.core.db import db
from indico.util.string import format_repr, return_ascii


class PaperCompetence(db.Model):
    __tablename__ = 'competences'
    __table_args__ = (db.UniqueConstraint('user_id', 'event_id'),
                      {'schema': 'event_paper_reviewing'})

    id = db.Column(
        db.Integer,
        primary_key=True
    )
    user_id = db.Column(
        db.Integer,
        db.ForeignKey('users.users.id'),
        index=True,
        nullable=False
    )
    event_id = db.Column(
        db.Integer,
        db.ForeignKey('events.events.id'),
        index=True,
        nullable=False
    )
    competences = db.Column(
        ARRAY(db.String),
        nullable=False,
        default=[]
    )

    event = db.relationship(
        'Event',
        lazy=True,
        backref=db.backref(
            'paper_competences',
            cascade='all, delete-orphan',
            lazy=True
        )
    )
    user = db.relationship(
        'User',
        lazy=True,
        backref=db.backref(
            'paper_competences',
            lazy='dynamic'
        )
    )

    @return_ascii
    def __repr__(self):
        return format_repr(self, 'id', 'user_id', 'event_id', _text=', '.join(self.competences))

    @classmethod
    def merge_users(cls, target, source):
        source_competences = source.paper_competences.all()
        target_competences_by_event = {x.event: x for x in target.paper_competences}
        for comp in source_competences:
            existing = target_competences_by_event.get(comp.event)
            if existing is None:
                comp.user_id = target.id
            else:
                existing.competences = list(set(existing.competences) | set(comp.competences))
                db.session.delete(comp)
