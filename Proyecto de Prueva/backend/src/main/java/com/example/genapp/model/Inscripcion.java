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
    scope = Inscripcion.class
)
public class Inscripcion {

        private BigDecimal costomatricula;
        @Id
        private String estado;
        private LocalDateTime fechainscripcion;
        private Integer id;
        private String numerofolio;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "boletin_id")
    @JsonIgnoreProperties(value = {"hibernateLazyInitializer", "handler"}, allowSetters = true)
    private Boletin boletin;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "curso_id")
    @JsonIgnoreProperties(value = {"hibernateLazyInitializer", "handler"}, allowSetters = true)
    private Curso curso;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "estudiante_id")
    @JsonIgnoreProperties(value = {"hibernateLazyInitializer", "handler"}, allowSetters = true)
    private Estudiante estudiante;

    @OneToMany(mappedBy = "inscripcion", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @JsonIgnoreProperties(value = {"inscripcion", "hibernateLazyInitializer", "handler"}, allowSetters = true)
    @lombok.Builder.Default
    private List<Calificacion> calificacion = new ArrayList<>();


    public void anularInscripcion(String motivo) {
    // TODO: implementar
    
    }
    public void confirmarInscripcion() {
    // TODO: implementar
    
    }
}
