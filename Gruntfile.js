module.exports = function(grunt) {

    // Project configuration.
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        coffee: {
            compile: {
                files: {
                    'js/<%= pkg.name %>.js': ['src/*.coffee', 'src/*/*.coffee'] // compile and concat into single file
                }
            },
        },
        uglify: {
            options: {
                banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
            },
            build: {
                src: 'js/<%= pkg.name %>.js',
                dest: 'js/<%= pkg.name %>.min.js'
            }
        },
        watch: {
            files: ['src/**'],
            tasks: ['default']
        }
    });

    // Load the plugin that provides the "uglify" task.
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-watch');

    // Default task(s).
    grunt.registerTask('default', ['coffee', 'uglify']);

};
