package com.example.genapp.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.*;
import com.example.genapp.model.Boletin;
import com.example.genapp.repository.BoletinRepository;

@Service
@RequiredArgsConstructor
public class BoletinService {

    private final BoletinRepository repository;

    public List<Boletin> findAll() {
        return repository.findAll();
    }

    public Optional<Boletin> findById(String id) {
        return repository.findById(id);
    }

    public Boletin save(Boletin e) {
        return repository.save(e);
    }

    public void delete(String id) {
        repository.deleteById(id);
    }
}
