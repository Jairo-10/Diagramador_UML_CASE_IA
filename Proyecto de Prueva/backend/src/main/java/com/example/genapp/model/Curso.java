package com.example.genapp.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.experimental.SuperBuilder;
import java.util.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;
import com.fasterxml.jackson.annotation.*;

@Entity
@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
@JsonIdentityInfo(
    generator = ObjectIdGenerators.PropertyGenerator.class,
    property = "id",
    scope = Curso.class
)
public class Curso {

        @Id
            @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long capacidadmax;
        private Integer id;
        private String nombre;
        private String turno;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cursoPadre_id")
    @JsonIgnoreProperties(value = {"hibernateLazyInitializer", "handler"}, allowSetters = true)
    private Curso cursoPadre;

    @OneToMany(mappedBy = "curso", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @JsonIgnoreProperties(value = {"curso", "hibernateLazyInitializer", "handler"}, allowSetters = true)
    @lombok.Builder.Default
    private List<Docente> docente = new ArrayList<>();
    @OneToMany(mappedBy = "curso", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @JsonIgnoreProperties(value = {"curso", "hibernateLazyInitializer", "handler"}, allowSetters = true)
    @lombok.Builder.Default
    private List<Inscripcion> inscripcion = new ArrayList<>();
    @OneToMany(mappedBy = "cursoPadre", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @JsonIgnoreProperties(value = {"cursoPadre", "hibernateLazyInitializer", "handler"}, allowSetters = true)
    @lombok.Builder.Default
    private List<Curso> subcursos = new ArrayList<>();


    public void cambiarTurno(String nuevoTurno) {
    // TODO: implementar
    
    }
    public Boolean validarCupo(Integer inscritos) {
    // TODO: implementar
    return false;
    }
}
